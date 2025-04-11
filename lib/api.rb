# frozen_string_literal: true
require 'openssl'
# require 'jwt'
# require 'octokit'
require 'dotenv/load'
require 'sinatra'
require_relative './webhook/server'

# APP_ID = ENV['GITHUB_APP_ID']
# PRIVATE_KEY_PATH = ENV['GITHUB_PRIVATE_KEY_PATH']
# private_key = OpenSSL::PKey::RSA.new(File.read(PRIVATE_KEY_PATH))

# payload = {
#   iat: Time.now.to_i,
#   exp: Time.now.to_i + (10 * 60),
#   iss: APP_ID
# }

# jwt = JWT.encode(payload, private_key, 'RS256')
# puts "Token -- #{jwt}"
# client = Octokit::Client.new(bearer_token: jwt)

# begin
#   installations = client.find_app_installations
# rescue Octokit::Unauthorized => e
#   puts "Authentication failed: #{e.message}"
#   exit
# end

# return unless installations.count >= 1

# installation_id = installations.first[:id]


# token_response = client.create_app_installation_access_token(installation_id)
# access_token = token_response[:token]

# installation_client = Octokit::Client.new(access_token: access_token)


def verify_signature(payload)
  secret = ENV['WEBHOOK_SECRET']
  expected_signature = 'sha256=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, payload)
  github_signature = request.env['HTTP_X_HUB_SIGNATURE_256']
  return halt 401, "Signature mismatch!" if github_signature.nil?
  
  unless Rack::Utils.secure_compare(expected_signature, github_signature)
    halt 401, "Signature mismatch"
  end
end

get "/" do
  "Hello world"
end

post "/webhook" do
  request.body.rewind
  body = request.body.read
  # verify_signature(body)

  event = request.env['HTTP_X_GITHUB_EVENT']
  payload = JSON.parse(body)
  WebHook.call(event, payload)
  status 200
end