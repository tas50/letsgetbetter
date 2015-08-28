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
    include CommandLineReporter
    def run
      header title: "#{Config.config['config']['github']['org']} Github Organization Report", width: 70, align: 'center', rule: true, color: 'green', bold: true
      table border: true do
        row header: true, color: 'red' do
          column 'Repo Name', width: 30, align: 'center', color: 'blue'
          column 'Issues', width: 15
          column 'Pull Requests', width: 15
          column 'Watchers', width: 10
        end

        parse_repos.each do |k, v|
          row color: 'green', bold: true do
            column "#{k}"
            column "#{v['issues']}"
            column '-'
            column "#{v['watchers']}"
          end
        end
      end
    end

    def parse_repos
      repo_results = {}
      Github.repos.each do |repo|
        repo_results[repo[:name]] = {}
        repo_results[repo[:name]]['issues'] = repo[:open_issues_count]
        repo_results[repo[:name]]['watchers'] = Github.watchers(repo[:name])
      end
      repo_results.sort_by { |_k, v| -v['issues'] }
    end
  end
end
