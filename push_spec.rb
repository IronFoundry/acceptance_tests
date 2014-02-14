require 'rspec'
require 'open-uri'

module IronFoundry
  describe "when targeting ironfoundry" do

    def runcf(cmd)
      expanded_cmd = "cf --script #{cmd} 2>&1"
      output = `#{expanded_cmd}`
      output = output.gsub(/Fast Debug.+\n/, '')
      return output
    end

    before :all do
      @domain= 'qa.ironfoundry.org'
      @endpoint = 'http://api.' + @domain
      @appname =  'ATApp01'
      @user = 'admin'
      @password = '<yourpasswordhere>'
      @test_org =  'Tier3'
      @test_space = 'T3QA'

      result = runcf("target #{@endpoint}")
      expect(result).to be_empty

      result = runcf("login --username #{@user} --password #{@password} --organization #{@test_org}  --space #{@test_space}")
      expect(result).to be_empty

      result = runcf('delete -all -routes')
      # expect(result).to match(/Unknown app/i).or eq('')
    end

    context 'when .net app is pushed' do
        before(:all) do
        @result = runcf("push #{@appname} --path assets\\asp_net_app --stack mswin-clr")
      end

      it 'reports success after push' do
        expect(@result).to match(/Push successful!/i)
      end

      it 'is addressable at expected endpoint' do
        response = open("http://#{@appname}.#{@domain}")
        expect(response.status).to include('200')
      end

      it 'health reports running'
      it 'reports application stats'
      it 'returns latest logs'
      it 'can be deleted'

    end
  end

end