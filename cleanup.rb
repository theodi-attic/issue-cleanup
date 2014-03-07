#!/usr/bin/env ruby

require 'github_api'

user = ARGV[0]
token = ARGV[1]

def bad?(text)
  return false if text.nil?
  [
    "auth_token="
  ].any? do |bad_thing|
    text.include?(bad_thing)
  end ? text : nil
end

github = Github.new do |config|
  config.oauth_token = token
end

page = 1
begin

  repos = github.repos.list user: user, per_page: 5, page: page
  page += 1

  repos.each do |repo|
  puts '---' + repo.owner.login + '/' + repo.name
    begin
      ['open', 'closed'].each do |state|
    
        issues = github.issues.list user: user, repo: repo.name, per_page: 10000, state: state
        issues.each do |issue|

          text = nil

          text = bad?(issue.body)
          
          if issue.comments > 0
            comments = github.issues.comments.all user, repo.name, issue_id: issue.number
            comments.each do |comment|
              text = bad?(comment.body)
            end
          end
    
          puts "#{issue.html_url}: #{text}" if text
    
        end
      end
    rescue Github::Error::ServiceError => ex
      raise unless ex.message.include?("Issues are disabled for this repo")
    end
  end
  
end until repos.empty?

