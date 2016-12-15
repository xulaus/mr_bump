# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'slack-notifier'
module MrBump
  # This class uses a slack webhook to push notifications to slack
  class Slack
    attr_accessor :webhook, :username, :jira_url, :icon, :git

    def initialize(git_config, config)
      opts = config['slack'] || {}
      raise ArgumentError, 'No Slack webhook found.' unless opts['webhook_url']
      @webhook = opts['webhook_url']
      @username = opts['username'] || 'Mr Bump'
      @jira_url = opts['jira_url']
      @icon = Array(opts['icon']).sample
      @config = config
      @git = git_config
    end

    def bump(version, changes)
      options = {}
      options[:icon_url] = @icon if @icon
      options[:attachments] = [attatchment(version, changes)]
      notifier.ping 'There is a new version bump!', options
    end

    def notifier
      @notifier ||= ::Slack::Notifier.new(@webhook, username: @username)
    end

    def jira_ids(changes)
      changes.split(/$\n?(?=\s*\*)/).map do |i|
        begin
          MrBump::Change.from_md(@config, i).dev_id
        rescue ArgumentError
          nil
        end
      end.compact
    end

    def jira_urls(changes)
      jira_ids(changes).map do |ticket|
        if ticket != 'UNKNOWN'
          "<#{@jira_url}/browse/#{ticket}|Jira link - #{ticket}>\n"
        end
      end.join
    end

    def jira_field(changes)
      if @jira_url && !@jira_url.empty?
        { value: jira_urls(changes), short: true, unfurl_links: false }
      end
    end

    def git_shas(changes)
      jira_ids(changes).map do |ticket|
        if ticket != 'UNKNOWN' && !@git.get_sha(ticket).nil?
          "<#{@git.repo_url}/commit/#{@git.get_sha(ticket)}|Git merge link - #{ticket}>\n"
        end
      end.join
    end

    # rubocop:disable Metrics/MethodLength
    def attatchment(version, changes)
      {
        fallback: changes,
        color: '#009de4',
        author_name: @git.user,
        author_icon: @git.user_icon,
        author_link: @git.user_link,
        fields: [
          { title: 'Version', value: version, short: true },
          { title: 'Repository', value: @git.repo_name, short: true },
          { title: 'Change Log', value: changes, short: false },
          jira_field(changes),
          { value: git_shas(changes), short: true }
        ],
        mrkdwn_in: %w(text title fallback fields)
      }
    end
  end
end
