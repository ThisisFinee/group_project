# frozen_string_literal: true

require './services/purchase_service'
require 'sinatra'

set :bind, '0.0.0.0'
set :port, 3000

configure do
  set :encoding, 'utf-8'
end

get '/' do
  'Hello, World!'
end

get '/purchase' do
  purchase = PurchaseService.new(params)
  result = purchase.call
  content_type :json
  result.to_json
end
