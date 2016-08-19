require 'mr_bump/version'
require 'mr_bump/slack'
require 'mr_bump/config'

module MrBump
  def self.current_branch
    @current_branch ||= `git rev-parse --abbrev-ref HEAD`
    @current_branch.strip
  end

  def self.current_uat_major
    prefix = 'origin/release/'
    vers = `git branch -r`
    regex = Regexp.new("^#{prefix}(\\d+\\.\\d+\\.0)$")
    vers = vers.each_line.map do |branch|
      branch = branch.strip
      MrBump::Version.new(branch.gsub(regex, '\1')) if branch[regex]
    end.compact
    vers.max
  end

  def self.current_uat
    uat = current_uat_major
    vers = `git tag -l`
    vers = vers.each_line.map do |branch|
      MrBump::Version.new(branch) rescue nil
    end.compact
    vers.select { |ver| ver.major == uat.major && ver.minor == uat.minor }.max
  end

  def self.current_master
    uat = current_uat_major
    vers = `git tag -l`
    vers = vers.each_line.map do |branch|
      MrBump::Version.new(branch) rescue nil
    end.compact
    vers.select { |ver| ver < uat }.max
  end

  def self.story_information(merge_str)
    merge_fmt = '^Merge pull request #(\d+) from Intellection/(bugfix|feature|hotfix)/(\w+[-_]?\d+)?'
    matches = Regexp.new(merge_fmt).match(merge_str)
    if matches
      type = matches[2].capitalize
      dev_id = (matches[3].nil? ? 'UNKNOWN' : matches[3])
      "#{type} - #{dev_id} - "
    end
  end

  def self.merge_logs(rev, head)
    git_cmd = "git log --pretty='format:%B' --grep '(^Merge pull request | into #{current_branch}$)' --merges -E"
    log = `#{git_cmd} #{rev}..#{head}`
    log.each_line.map(&:strip).select { |str| !(str.nil? || str == '') }
  end

  def self.ignored_merges_regex
    @ignored_merges_regex ||= begin
      ignored_branch = '(release|master|develop)'
      regex_pr = "^Merge pull request #\\d+ from Intellection/#{ignored_branch}"
      regex_manual = "^Merge branch '?#{ignored_branch}"
      Regexp.new("#{regex_pr}|#{regex_manual}")
    end
  end

  def self.change_log_items_for_range(rev, head)
    chunked_log = merge_logs(rev, head).chunk { |change| change[/^Merge/].nil? }
    chunked_log.each_slice(2).map do |merge_str, comment|
      merge_str = merge_str[1][0]
      unless merge_str[ignored_merges_regex]
        "\n* #{story_information(merge_str)}" + comment[1].join("\n  ")
      end
    end.compact
  end

  def self.file_prepend(file, str)
    new_contents = ''
    File.open(file, 'r') do |fd|
      contents = fd.read
      new_contents = str + contents
    end
    File.open(file, 'w') do |fd|
      fd.write(new_contents)
    end

    def self.config_file
      MrBump::Config.new().config
    end

    def self.slack_notifier(version, changelog)
      if config_file.key? 'slack'
        MrBump::Slack.new(config_file["slack"]).bump(version, changelog)
      end
    end

  end
end
