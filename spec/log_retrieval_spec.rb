require 'rspec'
require 'open-uri'
require './spec/when_targeting_ironfoundry_context.rb'

describe 'When app writes to log' do
  include_context 'when targeting ironfoundry'

  before(:all) do
    ensure_clean_app_is_pushed
    @log_entry = 'APostedLogMessage'

    log_cmd = "logs #{@appname}"
    @logs_before = execute(log_cmd)

    logResult=open(app_endpoint + "/api/log?entry=#{@log_entry}")
    expect(logResult.status).to include('200')

    @logs_after = execute(log_cmd)
  end

  it 'should not contain message in before command' do
    expect(@logs_before).to_not match(/#{@log_entry}/)
  end

  it 'should contain message in after command' do
    expect(@logs_after).to match(/#{@log_entry}/)
  end
end