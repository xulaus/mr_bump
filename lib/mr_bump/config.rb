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

    def config
      @config ||= if File.exist?(@config_file)
        YAML.load_file(@config_file) || {}
      else
        {}
      end
    end

    def default_file
      File.join(".mr_bump")
    end

  end
end
