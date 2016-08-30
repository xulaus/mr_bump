# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

require 'yaml'

module MrBump
  # This class sets up access to the config file
  class Config
    attr_reader :config_file

    def initialize(config_file = nil)
      @config_file = config_file || default_file
    end

    def defaults
      @defaults = begin
        defaults_yml = File.join(File.dirname(__FILE__), '..', '..', 'defaults.yml')
        YAML.load_file(defaults_yml)
      end
    end

    def config
      @config ||= begin
        loaded = YAML.load_file(@config_file) if File.exist?(@config_file)
        loaded ||= {}
        defaults.merge(loaded)
      end
    end

    def default_file
      File.join('.mr_bump')
    end
  end
end
