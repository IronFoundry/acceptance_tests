require 'rspec'
require 'open-uri'
require 'socket'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'when .net app is pushed' do
  include_context 'when targeting ironfoundry'

  before(:all) do
    ensure_app_is_deleted

    @push_result = execute("push #{@appname} #{@app_options}")
  end

  it 'reports success after push' do
    expect(@push_result).to match(/#0\s+running/i)
  end

  it 'is addressable at expected endpoint' do
    response = open(app_endpoint)
    expect(response.status).to include('200')
  end

  it 'is in the list of apps' do
    result = execute('apps')
    expect(result).to match(/#{@appname}/i)
  end

  it 'app status reports as running' do
    result = execute("app #{@appname}")
    expect(result).to match(/requested state: started/i)
    expect(result).to match(/#0\s+running/i)
  end

  it 'reports application stats'
  it 'returns latest logs'
  it 'can be pushed twice'
  it 'can set environment variables'
  it 'can push a node app (windows dea/warden can co-exist with linux dea/warden)'
  it 'should push multiple instances'
end

