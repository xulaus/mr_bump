# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'octokit'
module MrBump
  # This class makes calls to the github API
  class GitApi
    attr_accessor :client

    def initialize(token)
      @client = Octokit::Client.new(access_token: token)
    end

    def prs(repo_url)
      @prs ||= client.pull_requests(repo_url, state: 'open')
    end

    def sorted_prs(repo_url)
      prs(repo_url).map { |x| '#' + x[:number].to_s + ' - ' + x[:title].to_s + "\n" }.first(10).join
    end

    def merge_pr(repo_url, pr_id)
      client.merge_pull_request(repo_url, pr_id)
    end
  end
end
