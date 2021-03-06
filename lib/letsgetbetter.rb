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

# main orchestrator of letsgetbetter runs
module LetsGetBetter
  require 'command_line_reporter'
  require 'letsgetbetter/config.rb'
  require 'letsgetbetter/github.rb'
  require 'letsgetbetter/reporter.rb'
  require 'letsgetbetter/slack.rb'
  require 'yaml'
  require 'octokit'
  require 'faraday-http-cache'
  require 'pry'

  include LetsGetBetter::Config

  # main method used to kick off the run
  def self::run
    if ARGV[-1] == 'report'
      Reporter.new.run
    elsif ARGV[-1] == 'slack'
      LetsGetBetter::Slack.post
    else
      puts 'You must pass either report or slack actions. run letsgetbetter -h for usage'
    end
  end
end
