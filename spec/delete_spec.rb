require 'rspec'
require 'open-uri'
require 'socket'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'when .net app is deleted' do
  include_context 'when targeting ironfoundry'

  before(:all) do
    ensure_app_is_pushed

    @delete_result = execute("delete #{@appname} --routes")
  end

  it 'reports success after delete' do
    expect(@delete_result).to be_empty
  end

  it 'is not addressable at expected endpoint' do
    expect { open("http://#{@appname}.#{@domain}") }.to raise_error(/404/)
  end

  it 'is not in the list of apps' do
    result = execute('apps')
    expect(result).to_not match(/#{@appname}/i)
  end
end
