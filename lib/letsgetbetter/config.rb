# encoding: UTF-8
#
# Author:: Tim Smith (<tsmith84@gmail.com>)
# Copyright:: Copyright (c) 2015 Tim Smith
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module LetsGetBetter
  # allow fetching the config anywhere in the app
  module Config
    # return the config object or parse the options fresh
    def self.config
      @config ||= load_config
    end

    private_class_method

    def self.load_config
      merged_config = {}
      merged_config['options'] = parse_opts
      merged_config['config'] = config_file(merged_config['options']['config_file'])
      merged_config
    end

    def self.config_file(file)
      begin
        config = YAML.load(File.open(file))
      rescue Errno::ENOENT
        puts "Could not find a config file at #{file}!"
        exit!
      end
      config
    end

    # parse options passed from the command line
    def self.parse_opts
      options = { 'config_file' => './letsgetbetter.yml' }
      banner = "Lets Get Better - Help with managing open source projects in large Github Repos\n\n" \
                "Usage: letsgetbetter [options]\n\n" \
                "  Options:\n"
      optparse = OptionParser.new do |opts|
        opts.banner = banner
        opts.on('-c', '--config config.yml', String, 'Use the specified config file (defaults to ./config.yml)') do |c|
          options['config_file'] = c
        end
        opts.on('-o', '--org config.yml', String, 'Organization to analyze (required)') do |o|
          options['org'] = o
        end
        opts.on('-h', '--help', 'Displays Help') do
          puts opts
          exit
        end
      end

      # make sure the org val is passed
      if options['org'].nil?
        puts "\e[31mYou must pass an organization to poll!\e[0m\n\n"
        puts optparse
        exit!
      end

      optparse.parse!

      options
    end
  end
end
