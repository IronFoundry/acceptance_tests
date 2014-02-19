require 'rspec'
require 'socket'
require './EnvBackedAccessor'

shared_context 'when targeting ironfoundry' do

  env_accessor :user, :password, :domain, :test_org, :test_space

  def execute(cmd)
    expanded_cmd = "cf --script #{cmd} 2>&1"
    expanded_cmd.gsub('/', '\\') if RUBY_PLATFORM !~ /linux/

    output = `#{expanded_cmd}`
    output = output.gsub(/Fast Debug.+\n/, '')  # consume strings showing up
    return output
  end

  def ensure_app_is_deleted
    result = execute("delete #{@appname} --routes")
    expect(result).to match(/Unknown app/i) unless result.empty?
  end

  def ensure_clean_app_is_pushed
    ensure_app_is_deleted
    ensure_app_is_pushed
  end

  def ensure_app_is_pushed
    result = execute("push #{@appname} #{@app_options}")
    expect(result).to match(/Push successful!/i)
  end

  def ensure_app_is_stopped
    result = execute("stop #{@appname}")
    expect(result).to be_empty
  end

  def app_endpoint
    "http://#{@appname}.#{domain}"
  end

  before :all do
    # The following are backers for the accessors of the same name and may be overridden by environment variables IF_<variable>
    @domain = 'qa.ironfoundry.org'
    @user = 'admin'
    @password = '<enter your password>'
    @test_org =  'Tier3'
    @test_space = 'T3QA'

    @endpoint = 'http://api.' + domain
    @appname = Socket.gethostname.gsub(/\./,'-') + '-acceptance'
    #@app_options = '--path assets/asp_net_app --stack mswin-clr'
    @app_options = '--path assets/node_app --command "node app.js" '

    result = execute("target #{@endpoint}")
    expect(result).to be_empty

    result = execute("login --username #{user} --password #{password} --organization #{test_org}  --space #{test_space}")
    expect(result).to be_empty
  end
end
