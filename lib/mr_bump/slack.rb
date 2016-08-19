require 'slack-notifier'
require 'pry'
module MrBump
  # This class uses a slack webhook to push notifications to slack
  class Slack

    def initialize(opts)
      @webhook = opts["webhook_url"]
      @username = opts["username"]
      @icon = opts["icon"]
    end

    def bump(version, changes)
      options = {}
      options[:icon_url] = @icon
      options[:attachments] = [attatchment(version, changes)]
      puts 'notifying slack'
      notifier.ping "Mr Bump: new release!", options
    end

    def user
      [
        ENV["USER"],
        `whoami`
      ].compact.detect { |u| !u.nil? }
    end

    def client
      `git config --get remote.origin.url`[/[\w\.]+(?=\.git$)/]
    end

    def notifier
      @notifier ||= ::Slack::Notifier.new(@webhook, username: @username)
    end

    def attatchment(version, changes)
      {
        title: "#{user} has bumped #{client}",
        fallback: changes,
        fields: [
                  {title: 'Version', value: version},
                  {title: 'Change Log', value: changes}
                ],
        mrkdwn_in: ["text", "title", "fallback", "fields"]
      }
    end


  end
end
