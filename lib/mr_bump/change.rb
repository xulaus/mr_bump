require 'mustache'

module MrBump
  # This class acts parses merge information from a commit message string
  class Change
    attr_reader :pr_number, :branch_type, :dev_id, :config, :comment_lines

    BRANCH_FMT = '(?<branch_type>bugfix|feature|hotfix)/(?<dev_id>\w+[-_]?\d+)?[\\w\\-_]+'.freeze
    MERGE_PR_FMT = "^Merge pull request #(?<pr_number>\\d+) from [\\w\\-_]+/#{BRANCH_FMT}".freeze
    MERGE_MANUAL_FMT = "^Merge branch '#{BRANCH_FMT}'".freeze
    MERGE_REGEX = Regexp.new(MERGE_PR_FMT + '|' + MERGE_MANUAL_FMT).freeze

    def initialize(config, commit_msg, comment_lines)
      matches = MERGE_REGEX.match(commit_msg)
      raise ArgumentError, "Couldn't extract merge information from commit message " \
                           "'#{commit_msg}'" unless matches
      @config = config
      @branch_type = matches['branch_type'].capitalize
      @dev_id = matches['dev_id'] || 'UNKNOWN'
      @pr_number = matches['pr_number'] || ''
      @comment_lines = Array(comment_lines)
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
  end
end
