require 'rspec'
require 'open-uri'
require 'socket'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'when running .net app is started' do
  include_context 'when targeting ironfoundry'

  before(:all) do
    ensure_app_is_pushed
    ensure_app_is_stopped

    @start_result = execute("start #{@appname}")
  end

  it 'reports success' do
    expect(@start_result).to match(/push successful/i)
  end

  it 'is addressable at expected endpoint' do
    response = open("http://#{@appname}.#{@domain}")
    expect(response.status).to include('200')
  end

  it 'health reports as running' do
    result = execute("health #{@appname}")
    expect(result).to match(/running/i)
  end
end

