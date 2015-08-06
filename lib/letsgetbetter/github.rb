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
  # Fetches the Github org state
  class Github
    def self.gh_connection
      @connection ||= open_connection
    end

    def self.open_connection
      connection = Octokit::Client.new(:access_token => Config.config['config']['github']['token'])
      connection.auto_paginate = true
      connection
    end

    def self.repos
      gh_connection.organization_repositories(Config.config['config']['github']['org'])
    end
  end
end
