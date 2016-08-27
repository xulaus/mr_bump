# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

module MrBump
  # This class gathers configuration infromation from git
  class GitConfig
    attr_reader :user, :username, :repo_url, :repo_name, :orgin
    GITHUB_URL_REGEX = Regexp.new(
      '(https?://((?<user>[\w_\-\d]+)@)?|git@)(?<domain>github.com)[:/](?<path>[\w_\-\d]+)/' \
      '(?<repo_name>[\w_\-\d\.]+?)(\.git)?$'
    ).freeze

    def initialize(origin, repo_name, repo_url, username, user)
      @origin = origin
      @repo_name = repo_name
      @repo_url = repo_url
      @username = username
      @user = user || `git config user.name`
    end

    def self.from_origin(origin, user = nil)
      match = GITHUB_URL_REGEX.match(origin)
      raise ArgumentError,
            "Couldn't parse needed information from remote url '#{git_url}'" unless match
      GitConfig.new(
        origin,
        match['repo_name'],
        "https://#{match['domain']}/#{match['path']}/#{match['repo_name']}/",
        match['user'],
        user
      )
    end

    def self.from_current_path
      from_origin(`git remote get-url origin`.strip)
    end

    def user_icon
      'https://avatars.githubusercontent.com/' + username if username
    end

    def user_link
      'https://github.com/' + username if username
    end

    def get_sha(pattern)
      `git log --grep=#{pattern} --merges --format=format:%H`.split("\n").first
    end
  end
end
