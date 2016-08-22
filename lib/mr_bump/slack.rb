require 'slack-notifier'
module MrBump
  # This class uses a slack webhook to push notifications to slack
  class Slack

    def initialize(opts)
      raise ArgumentError, 'No Slack webhook found.' unless opts["webhook_url"]
      @webhook = opts["webhook_url"]
      @username = opts["username"] || 'Mr Bump'
      if opts['jira_url']
        @jira_url = opts['jira_url']
      else
        @jira_url = nil
      end
      if opts['icon']
        @icon = (opts['icon'].is_a? Array) ? opts['icon'].sample : opts['icon']
      end
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

    def user
      `git config user.name`.gsub(/\n/, '')
    end

    def git_url
      @git_url ||= `git remote get-url origin`
    end

    def git_user
      git_url[/[^@]+/].partition('//').last
    end

    def git_icon
      'https://avatars.githubusercontent.com/' + git_user
    end

    def git_link
      'https://github.com/' + git_user
    end

    def repo_name
      `git config --get remote.origin.url`[/[\w\.]+(?=\.git$)/]
    end

    def jira_ids(changes)
      changes.split('* ').map { |i| i.split(' - ',3)[1]}.compact
    end

    def jira_urls(changes)
      jira_ids(changes).map do |ticket|
        if ticket!= 'UNKNOWN'
          '<' + @jira_url + '/browse/' + ticket + '|Jira link - ' + ticket + ">\n"
        end
      end.join
    end

    def jira_field(changes)
      if @jira_url && !@jira_url.empty?
        {value: jira_urls(changes), short: true, unfurl_links: false}
      end
    end

    def get_sha(id)
      `git log --grep=#{id} --merges --format=format:%H`.split("\n").first
    end

    def git_repo_url
      'https://' + git_url.partition('@').last.gsub(".git\n", '')
    end

    def git_shas(changes)
      jira_ids(changes).map do |ticket|
        if ticket!= 'UNKNOWN' && !get_sha(ticket).nil?
          '<' + git_repo_url + '/commit/'  + get_sha(ticket) + '|Git merge link - ' + ticket + ">\n"
        end
      end.join
    end


    def attatchment(version, changes)
      {
        fallback: changes,
        color: "#009de4",
        author_name: user,
        author_icon: git_icon,
        author_link: git_link,
        fields: [
                  {title: 'Version', value: version, short: true},
                  {title: 'Repository', value: repo_name, short: true},
                  {title: 'Change Log', value: changes, short: false},
                  jira_field(changes),
                  {value: git_shas(changes), short: true}
                ],
        mrkdwn_in: ["text", "title", "fallback", "fields"]
      }
    end


  end
end
