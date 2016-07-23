# encoding: UTF-8
#
# Author:: Tim Smith (<tsmith84@gmail.com>)
# Copyright:: Copyright (c) 2016 Tim Smith
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
  class Slack

    def self.post
      require 'slack/post'

      ::Slack::Post.configure(
        webhook_url: Config.config['config']['slack']['webhook_url'],
        username: 'LetsGetBetter',
        icon_url: 'https://www.chef.io/favicon-bc338548.png'
        )
        #binding.pry
      ::Slack::Post.post message
    end

    def self.days_ago(date)
      Date.today.mjd - Date.parse(date.strftime('%Y/%m/%d')).mjd
    end

    def self.message
      oldest = Reporter.new.oldest_issues_and_prs

      msg = "It looks like you have some time. How about working the backlog!\n\n"
      msg << "*Oldest issue:* #{days_ago(oldest[0]['created_at'])} days old: https://github.com/#{Config.config['options']['org']}/#{oldest[0]['repository']}/issues/#{oldest[0]['number']}/\n"
      msg << "*Oldest PR:* #{days_ago(oldest[1]['created_at'])} days old: https://github.com/#{Config.config['options']['org']}/#{oldest[1]['repository']}/pull/#{oldest[1]['number']}/\n"
      msg
    end
  end
end
