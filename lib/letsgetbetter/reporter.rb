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
  # Presents the github org state
  class Reporter
    def self.run
      parse_repos.each do |k, v|
        puts "#{k}: #{v['issues']} open issues"
      end
    end

    def self.parse_repos
      repo_results = {}
      Github.repos.each do |repo|
        repo_results[repo[:name]] = {}
        repo_results[repo[:name]] = { 'issues' => repo[:open_issues_count] }
      end
      repo_results
    end
  end
end
