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

    # return array of issues and array of PRs for the passed repo
    def repo_issues_and_prs(repo = nil)
      issue_ar = []
      pr_ar = []
      LetsGetBetter::Github.issues.each do |_id, issue_data|
        next unless issue_data['repository'] == repo || repo.nil?
        # sort based on the identified type
        if issue_data['is_pr']
          pr_ar << issue_data
        else
          issue_ar << issue_data
        end
      end
      [issue_ar, pr_ar]
    end

    def oldest_issues_and_prs(repo = nil)
      repos = LetsGetBetter::Github.repos
      oldest_issue_time = Time.new
      oldest_issue = {}
      oldest_pr_time = Time.new
      oldest_pr = {}

      repo_issues_and_prs(repo)[0].each do |issue|
        next unless repos.include?(issue['repository'])
        if issue['created_at'] < oldest_issue_time
          oldest_issue_time = issue['created_at']
          oldest_issue = issue
        end
      end

      repo_issues_and_prs(repo)[1].each do |issue|
        if issue['created_at'] < oldest_pr_time
          oldest_pr_time = issue['created_at']
          oldest_pr = issue
        end
      end
      [oldest_issue, oldest_pr]
    end

    def run
      header title: "#{Config.config['options']['org']} Github Organization Report", width: 80, align: 'center', rule: true, color: 'green', bold: true
      table border: true do
        row header: true, color: 'red' do
          column 'Repo Name', width: 40, align: 'center', color: 'blue'
          column 'Open PRs', width: 10
          column 'Issues', width: 10
          column 'Oldest PR', width: 10
          column 'Oldest Issue', width: 10
        end

        LetsGetBetter::Github.repos.each do |repo|
          issues, prs = repo_issues_and_prs(repo)
          old_ones = oldest_issues_and_prs(repo)

          row color: 'green', bold: true do
            column "#{repo}"
            column "#{prs.count}"
            column "#{issues.count}"
            column "#{old_ones[1]['created_at']}"
            column "#{old_ones[0]['created_at']}"
          end
        end

        all_issues, all_prs = repo_issues_and_prs
        puts 'Totals:'
        puts "Repos: #{LetsGetBetter::Github.repos.count}"
        puts "Pull requests: #{all_prs.count}"
        puts "Issues: #{all_issues.count}"
      end
    end
  end
end
