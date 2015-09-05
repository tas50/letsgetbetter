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
          column 'Open PRs', width: 10
          column 'Issues', width: 10
          column 'Watchers', width: 10
        end

        repos = parse_repos
        repos['repos'].each do |k, v|
          row color: 'green', bold: true do
            column "#{k}"
            column "#{v['pull_requests']}"
            column "#{v['issues']}"
            column "#{v['watchers']}"
          end
        end
      end

      puts "Totals:"
      puts "Repos: #{repos['repos'].count}"
      puts "Pull requests: #{repos['total']['pull_requests']}"
      puts "Issues: #{repos['total']['issues']}"
      puts "Watchers: #{repos['total']['watchers']}"
    end

    def parse_repos
      repo_results = {}
      repo_results['repos'] = {}
      repo_results['total'] = {}
      %w(pull_requests issues watchers).each do |item|
        repo_results['total'][item] = 0
      end

      Github.repos.each do |repo|
        repo_results['repos'][repo[:name]] = {}

        prs = Github.pull_requests(repo[:name])
        repo_results['repos'][repo[:name]]['pull_requests'] = prs
        repo_results['total']['pull_requests'] += prs

        issues = repo[:open_issues_count] - repo_results['repos'][repo[:name]]['pull_requests']
        repo_results['repos'][repo[:name]]['issues'] = issues
        repo_results['total']['issues'] += issues

        watchers = Github.watchers(repo[:name])
        repo_results['repos'][repo[:name]]['watchers'] = watchers
        repo_results['total']['watchers'] += watchers
      end
      repo_results['repos'].sort_by { |_k, v| -v['pull_requests'] }
      repo_results
    end
  end
end
