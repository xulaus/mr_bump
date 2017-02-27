# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'yaml'

module MrBump
  # This class sets up access to the config file
  class Config
    attr_reader :config_file

    def initialize(config_file = nil)
      @config_file = config_file || default_project_filename
    end

    def user_config_file
      File.join(Dir.home, '.mr_bump.yml')
    end

    def default_project_filename
      File.join('.mr_bump')
    end

    def default_config
      @default_config = begin
        special_config = { 'projects' => Hash.new('Miscellaneous') }
        defaults_yml = File.join(File.dirname(__FILE__), '..', '..', 'defaults.yml')
        special_config.merge(YAML.load_file(defaults_yml))
      end
    end

    def user_config
      @user_config = begin
        loaded = YAML.load_file(user_config_file) if File.exist?(user_config_file)
        loaded || {}
      end
    end

    def project_config
      @project_config ||= begin
        loaded = YAML.load_file(@config_file) if File.exist?(@config_file)
        loaded || {}
      end
    end

    def config
      @config ||= deep_merge(deep_merge(default_config, user_config), project_config)
    end

    def deep_merge(hash1, hash2)
      return hash2 unless (hash2.is_a?(Hash) && hash1.is_a?(Hash)) || hash2.nil?
      return hash1 if hash2.nil?
      hash1.dup.tap do |master|
        hash2.keys.each do |key|
          master[key] = deep_merge(master.fetch(key, nil), hash2.fetch(key, nil))
        end
      end
    end
  end
end
