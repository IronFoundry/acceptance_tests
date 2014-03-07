require 'rspec'
require 'open-uri'
require 'json'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'when environment variable set on app' do
  include_context 'when targeting ironfoundry'

  before(:all) do
    ensure_clean_app_is_pushed
    @set_result = execute("set-env #{@appname} #{@environment_key} #{@environment_value}")

    # Re-push app to update variables
    ensure_app_is_pushed
  end

  it 'should indicate success' do
    expect(@set_result).to match(/^OK$/i)
  end

  it 'should be visible to the app' do
    response = open(app_endpoint + "/api/environment/#{@environment_key}")
    expect(response.status).to include('200')

    json = JSON.parse(response.read)
    expect(json['Value']).to eq(@environment_value)
  end

end