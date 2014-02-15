require 'rspec'
require 'open-uri'
require 'socket'

module IronFoundry
  describe 'when targeting ironfoundry' do

    def execute(cmd)
      expanded_cmd = "cf --script #{cmd} 2>&1"
      expanded_cmd.gsub('/', '\\') if RUBY_PLATFORM !~ /linux/

      output = `#{expanded_cmd}`
      output = output.gsub(/Fast Debug.+\n/, '')
      return output
    end

    def ensure_app_is_deleted
      result = execute("delete #{@appname} --routes")
      expect(result).to match(/Unknown app/i) unless result.empty?
    end

    def ensure_app_is_pushed
      ensure_app_is_deleted
      result = execute("push #{@appname} #{@app_options}")
      expect(result).to match(/Push successful!/i)
    end

    before :all do
      @domain= 'qa.ironfoundry.org'
      @endpoint = 'http://api.' + @domain
      @appname = Socket.gethostname + '-acceptance'
      @app_options = '--path assets/asp_net_app --stack mswin-clr'
      #@app_options = '--path assets/node_app --command "node app.js" '
      @user = 'admin'
      @password = 'put-password-here'
      @test_org =  'Tier3'
      @test_space = 'T3QA'

      result = execute("target #{@endpoint}")
      expect(result).to be_empty

      result = execute("login --username #{@user} --password #{@password} --organization #{@test_org}  --space #{@test_space}")
      expect(result).to be_empty
    end

    context 'when .net app is pushed' do
      before(:all) do
        ensure_app_is_deleted

        @push_result = execute("push #{@appname} #{@app_options}")
      end

      it 'reports success after push' do
        expect(@push_result).to match(/Push successful!/i)
      end

      it 'is addressable at expected endpoint' do
        response = open("http://#{@appname}.#{@domain}")
        expect(response.status).to include('200')
      end

      it 'is in the list of apps' do
        result = execute('apps')
        expect(result).to match(/#{@appname}/i)
      end

      it 'health reports as running' do
        result = execute("health #{@appname}")
        expect(result).to match(/running/i)
      end

      it 'reports application stats'
      it 'returns latest logs'
      it 'can be pushed twice'
      it 'can set environment variables'
      it 'can push a node app (windows dea/warden can co-exist with linux dea/warden)'

    end

    context 'when .net app is deleted' do
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

    context 'when running .net app is stopped' do
      before(:all) do
        ensure_app_is_pushed

        @stop_result = execute("stop #{@appname}")
      end

      it 'reports success' do
        expect(@stop_result).to be_empty
      end

      it 'is not addressable at expected endpoint' do
        expect { open("http://#{@appname}.#{@domain}") }.to raise_error(/404/)
      end

      it 'health reports as stopped' do
        result = execute("health #{@appname}")
        expect(result).to match(/stopped/i)
      end

    end
  end
end
