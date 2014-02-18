require 'rspec'
require 'open-uri'
require 'socket'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'when running .net app is stopped' do
  include_context 'when targeting ironfoundry'

  before(:all) do
    ensure_app_is_pushed

    @stop_result = execute("stop #{@appname}")
  end

  it 'reports success' do
    expect(@stop_result).to be_empty
  end

  it 'is not addressable at expected endpoint' do
    expect { open(app_endpoint) }.to raise_error(/404/)
  end

  it 'health reports as stopped' do
    result = execute("health #{@appname}")
    expect(result).to match(/stopped/i)
  end
end
