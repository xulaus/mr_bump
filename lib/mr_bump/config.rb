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
        defaults_yml = File.join(File.dirname(__FILE__), '..', '..', 'defaults.yml')
        YAML.load_file(defaults_yml)
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
      @config ||= default_config.merge(user_config).merge(project_config)
    end
  end
end
