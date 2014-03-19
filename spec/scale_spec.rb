require 'rspec'
require 'open-uri'
require 'socket'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'when .net app is scaled to multiple instances' do
  include_context 'when targeting ironfoundry'

  before(:all) do
    ensure_clean_app_is_pushed

    @scale_result = execute("scale #{@appname} -i 2")
  end

  it 'reports success after scaling' do
    expect(@scale_result).to match(/OK/i)
  end

  it 'is addressable at expected endpoint' do
    response = open(app_endpoint)
    expect(response.status).to include('200')
  end

  it 'has all instances in rotation' do
    response = open(app_endpoint + "/api/instance")
    first_process_id = response.read
    second_process_id = ''

    for i in 0..100
      response = open(app_endpoint + "/api/instance")
      second_process_id = response.read
      break if first_process_id != second_process_id
      sleep(0.25)
    end

    expect(first_process_id).to_not eq(second_process_id)
  end

  it 'app status reports all instances as running' do
    result = execute("app #{@appname}")
    expect(result).to match(/#0\s+running/i)
    expect(result).to match(/#1\s+running/i)
  end
end
