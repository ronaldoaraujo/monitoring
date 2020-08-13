require 'sinatra'
require_relative 'online_assigner'

helpers do
  def json_params
    begin
      JSON.parse(request.body.read)
    rescue
      halt 400, { message: 'Invalid JSON' }.to_json
    end
  end
end

post '/data' do
  OnlineAssigner.(json_params)

  'OK'
end
