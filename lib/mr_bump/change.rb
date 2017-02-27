# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'mustache'
require 'mr_bump/regex_template'

module MrBump
  # This class acts parses merge information from a commit message string
  class Change
    attr_reader :pr_number, :branch_type, :dev_id, :config, :comment_lines, :branch_name

    BRANCH_TYPES = %w(Bugfix Feature Hotfix Task).freeze

    FORMATS = {
      dev_id: '\w+[-_]?\d+',
      branch_type: "#{BRANCH_TYPES.join('|')}",
      pr_number: '\d+',
      first_comment_line: '(?=\w)[^\n]*',
      comment_body: '(?=\w)[^\n]*'
    }.freeze

    BRANCH_FMT = "((?<branch_type>#{FORMATS[:branch_type]})/)?(?<branch_name>(?<dev_id>#{FORMATS[:dev_id]})?([\\w\\d\\-_/\\.])*)".freeze
    MERGE_PR_FMT = "^Merge pull request #(?<pr_number>#{FORMATS[:pr_number]}) from [\\w\\-_]+/#{BRANCH_FMT}/?".freeze
    MERGE_MANUAL_FMT = "^Merge branch '(#{BRANCH_FMT}/?)'".freeze
    MERGE_REGEX = Regexp.new(MERGE_PR_FMT + '|' + MERGE_MANUAL_FMT, 'i').freeze

    def initialize(config, branch_type = nil, branch_name = nil, dev_id = nil, pr_number = nil, comment_lines = nil)
      @config = config
      @branch_type = (branch_type || 'Task')
      @branch_name = branch_name
      @dev_id = dev_id
      @pr_number = pr_number || ''
      @comment_lines = Array(comment_lines)
      unless @comment_lines.empty? || @dev_id.nil?
        id = Regexp.escape(@dev_id)
        prefix_regex = /^(\[#{id}\]|\(#{id}\)|#{id})\s*([:\-]\s*)?/
        @comment_lines[0] = @comment_lines[0].sub(prefix_regex, '')
      end
    end

    def has_no_detail?
      comment_lines.empty? && dev_id.nil?
    end

    def first_comment_line
      comment_lines.first
    end

    def comment_body
      comment_lines[1..-1] if comment_lines.size > 1
    end

    def to_md
      Mustache.render(config['markdown_template'], self)
    end

    def self.from_gitlog(config, commit_msg, comment_lines)
      matches = MERGE_REGEX.match(commit_msg)
      raise ArgumentError, "Couldn't extract merge information from commit message " \
                           "'#{commit_msg}'" unless matches
      Change.new(
        config,
        (matches['branch_type'] || 'task').capitalize,
        matches['branch_name'],
        matches['dev_id'],
        matches['pr_number'],
        comment_lines
      )
    end

    def self.from_md(config, md)
      regex = RegexTemplate.render(config['markdown_template'], FORMATS, 'i')
      matches = regex.match md
      raise ArgumentError, "Couldn't extract merge information from markdown " \
                           "'#{md}'" unless matches
      # Convert whole string matches into smaller individual matches
      match_hash = FORMATS.map do |key, reg|
        key = key.to_s
        find = matches.names.include?(key) ? matches[key] : ''
        [key.to_s, find.scan(Regexp.new(reg)).reject(&:empty?)]
      end
      match_hash = Hash[match_hash]

      comment_lines = match_hash['first_comment_line'] + match_hash['comment_body']

      Change.new(
        config,
        (match_hash['branch_type'].first || 'task').capitalize,
        nil,
        match_hash['dev_id'].first,
        match_hash['pr_number'].first,
        comment_lines
      )
    end
  end
end
