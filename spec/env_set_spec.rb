require 'rspec'
require 'open-uri'
require 'json'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'when environment setting set on app' do
  include_context 'when targeting ironfoundry'

  ENVIRONMENT_KEY = 'TestEnvKey'
  ENVIRONMENT_VALUE = 'TestEnvValue'

  before(:all) do
    ensure_clean_app_is_pushed
    @set_result = execute("set-env #{@appname} #{ENVIRONMENT_KEY} #{ENVIRONMENT_VALUE}")

    # Re-push app to update variables
    ensure_app_is_pushed
  end

  it 'should return empty for set result' do
    expect(@set_result).to eq("TIP: Use 'cf push' to ensure your env variable changes take effect.\n")
  end

  it 'should be visible to the app' do
    response = open(app_endpoint + "/api/environment/#{ENVIRONMENT_KEY}")
    expect(response.status).to include('200')

    json = JSON.parse(response.read)
    expect(json['Value']).to eq(ENVIRONMENT_VALUE)
  end

end