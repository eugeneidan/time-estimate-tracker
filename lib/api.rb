# frozen_string_literal: true
require 'openssl'
# require 'jwt'
# require 'octokit'
require 'dotenv/load'
require 'sinatra'
require_relative './webhook/server'



## verify signature for payload
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
  ##uncomment this for testing purposes
  verify_signature(body)

  event = request.env['HTTP_X_GITHUB_EVENT']
  payload = JSON.parse(body)
  WebHook.call(event, payload)
  status 200
end