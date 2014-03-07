require 'rspec'
require 'open-uri'
require 'json'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'when environment variable unset from app' do
  include_context 'when targeting ironfoundry'

  before(:all) do
    ensure_clean_app_is_pushed
    result = execute("set-env #{@appname} #{@environment_key} #{@environment_value}")
    expect(result).to match(/^OK$/i)

    # Re-push app to update variables
    ensure_app_is_pushed
    @clear_result = execute("unset-env #{@appname} #{@environment_key}")
    ensure_app_is_pushed
  end

  it 'should indicate success' do
    expect(@clear_result).to match(/^OK$/i)
  end

  it 'should not be visible to the app' do
    expect { open(app_endpoint + "/api/environment/#{@environment_key}") }.to raise_error(/404/)
  end

end