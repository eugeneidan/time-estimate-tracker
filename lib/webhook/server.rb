# frozen_string_literal: true

require 'json'
require 'octokit'
require 'openssl'
require 'jwt'
require 'dotenv/load'

APP_ID = ENV['GITHUB_APP_ID']
PRIVATE_KEY_PATH = ENV['GITHUB_PRIVATE_KEY_PATH']
PRIVATE_KEY = OpenSSL::PKey::RSA.new(File.read(PRIVATE_KEY_PATH))

def generate_jwt
  payload = {
    iat: Time.now.to_i,
    exp: Time.now.to_i + (10 * 60),
    iss: APP_ID
  }
  JWT.encode(payload, PRIVATE_KEY, 'RS256')
end

WebHook = lambda do |event, payload|
  # puts "Receiving payload -- #{payload}"
  data = payload['payload']
  return unless event == 'issues' && payload['action'] == 'opened'
  # puts "Replying comments --- "
  issue = data['issue']
  issue_body = issue['body'] || ''
  repo = data['repository']
  owner = repo['owner']['login']
  repo_name = repo['name']
  issue_number = issue['number']

  unless issue_body.match?(/Estimate\s*[:=]\s*\d+/i)
    jwt = generate_jwt
    app_client = Octokit::Client.new(bearer_token: jwt)
    installation_id = data['installation']['id']
    token_response = app_client.create_app_installation_access_token(installation_id)
    client = Octokit::Client.new(access_token: token_response[:token])
    # use a proper loggger
    puts "Replying comments --- "
    comment = "Please provide an `Estimate: <number of hours>` in the issue description."
    client.add_comment("#{owner}/#{repo_name}", issue_number, comment)
    # use a proper logger
    puts "Comment added to issue ##{issue_number} in #{owner}/#{repo_name}"
  end
end
