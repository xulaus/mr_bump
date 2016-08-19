require 'slack-notifier'
module MrBump
  # This class uses a slack webhook to push notifications to slack
  class Slack

    def initialize(opts)
      @webhook = opts["webhook_url"] || (raise ArgumentError, 'No Slack webhook found. Add a webhook to your .mr_bump config')
      @username = opts["username"] || 'Mr Bump'
      @icon = opts["icon"] || "../../assets/img/mr_bump.png"
    end

    def bump(version, changes)
      options = {}
      options[:icon_url] = @icon
      options[:attachments] = [attatchment(version, changes)]
      notifier.ping ' ', options
    end

    def user
      [
        ENV["USER"],
        `whoami`
      ].compact.detect { |u| !u.nil? }
    end

    def repo_name
      `git config --get remote.origin.url`[/[\w\.]+(?=\.git$)/]
    end

    def notifier
      @notifier ||= ::Slack::Notifier.new(@webhook, username: @username)
    end

    def attatchment(version, changes)
      {
        title: "#{user} has bumped #{repo_name}",
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
