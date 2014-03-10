require 'rspec'
require 'open-uri'
require 'socket'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'when stopped .net app is started' do
  include_context 'when targeting ironfoundry'

  before(:all) do
    ensure_clean_app_is_pushed
    ensure_app_is_stopped

    @start_result = execute("start #{@appname}")
  end

  it 'reports success' do
    expect(@start_result).to match(/app started/i)
    expect(@start_result).to match(/#0\s+running/i)
  end

  it 'is addressable at expected endpoint' do
    response = open(app_endpoint)
    expect(response.status).to include('200')
  end

  it 'app status reports as running' do
    result = execute("app #{@appname}")
    expect(result).to match(/requested state: started/i)
    expect(result).to match(/#0\s+running/i)
  end
end

