require 'rspec'
require 'open-uri'
require 'json'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'when environment setting unset from app' do
  include_context 'when targeting ironfoundry'

  ENVIRONMENT_KEY = 'TestEnvKey'
  ENVIRONMENT_VALUE = 'TestEnvValue'

  before(:all) do
    ensure_app_is_pushed
    set_result = execute("set-env #{@appname} #{ENVIRONMENT_KEY} #{ENVIRONMENT_VALUE}")
    expect(set_result).to eq("TIP: Use 'cf push' to ensure your env variable changes take effect.\n")

    # Re-push app to update variables
    push_app
    @clear_result = execute("unset-env #{@appname} #{ENVIRONMENT_KEY}")
    push_app
  end

  it 'should return empty for clear result' do
    expect(@clear_result).to eq("TIP: Use 'cf push' to ensure your env variable changes take effect.\n")
  end

  it 'should not be visible to the app' do
    expect { open(app_endpoint + "/api/environment/#{ENVIRONMENT_KEY}") }.to raise_error(/404/)
  end

end