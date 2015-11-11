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
      header title: "#{Config.config['options']['org']} Github Organization Report", width: 70, align: 'center', rule: true, color: 'green', bold: true
      table border: true do
        row header: true, color: 'red' do
          column 'Repo Name', width: 30, align: 'center', color: 'blue'
          column 'Open PRs', width: 10
          column 'Issues', width: 10
          column 'Watchers', width: 10
          column 'Forks', width: 10
        end

        repos = LetsGetBetter::Github.repos_details
        repos.each do |repo, data|
          row color: 'green', bold: true do
            column "#{repo}"
            column "#{data['pr_count']}"
            column "#{data['issue_count']}"
            column "#{data['watcher_count']}"
            column "#{data['fork_count']}"
          end
        end

        puts 'Totals:'
        puts "Repos: #{repos.count}"
        puts 'Pull requests: na'
        puts 'Issues: na'
        puts "Watchers: na\n"
      end
    end
  end
end
