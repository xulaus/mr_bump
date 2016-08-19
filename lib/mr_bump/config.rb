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
