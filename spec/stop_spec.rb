require 'rspec'
require 'open-uri'
require 'socket'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'when running .net app is stopped' do
  include_context 'when targeting ironfoundry'

  before(:all) do
    ensure_clean_app_is_pushed

    @stop_result = execute("stop #{@appname}")
  end

  it 'reports success' do
    expect(@stop_result).to match(/^OK$/i)
  end

  it 'is not addressable at expected endpoint' do
    expect { open(app_endpoint) }.to raise_error(/404/)
  end

  it 'app status reports as stopped' do
    result = execute("app #{@appname}")
    expect(result).to match(/requested state: stopped/i)
    expect(result).to match(/There are no running instances of this app/i)
  end
end
