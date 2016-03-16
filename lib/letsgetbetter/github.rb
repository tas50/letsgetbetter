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
    # return array of issues
    def self.issues
      unless @all_issues
        all_data = gh_connection.org_issues(Config.config['options']['org'], filter: 'all')
        @all_issues = {}
        all_data.each do |issue|
          next unless issue['state'] == 'open'
          temp = {}
          temp['created_at'] = issue['created_at']
          temp['updated_at'] = issue['updated_at']
          temp['repository'] = issue['repository']['name']
          temp['comments'] = issue['comments']
          temp['number'] = issue['number']
          temp['is_pr'] =  issue['pull_request'] ? true : false
          @all_issues["#{issue['id']}"] = temp
        end
      end
      @all_issues
    end

    # return an array of the repos
    def self.repos
      @repos ||= gh_connection.org_repos(Config.config['options']['org'], type: Config.config['options']['repo_types'] || 'public').collect { |x| x[:name] }
    end

    private

    # return the connection or set a new one up
    def self.gh_connection
      unless @connection
        @connection = Octokit::Client.new(access_token: Config.config['config']['github']['token'])
        @connection.auto_paginate = true
      end
      @connection
    end
  end
end
