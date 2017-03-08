require 'spec_helper'
describe 'Tomcat should be ready' do
  describe service('tomcat_default') do
    it { should be_enabled }
    it { should be_running }
  end
  it 'is listening on port 8080' do
    expect(port(8080)).to be_listening
  end

  # setenv is only created on centos 6
  describe file('/opt/tomcat/bin/setenv.sh'),
  if: (os[:family] == 'redhat' && os[:release] == '6') do
    its(:content) { should match Regexp.new("(((CATALINA_OPTS=)(.)((-[a-zA-Z]+[0-9]+[a-zA-Z][ ]+)|(-[a-zA-Z:]+=)[0-9]+[a-zA-Z][ ])+.+)|(CATALINA_OPTS=''))") }
    its(:content) { should contain 'CATALINA_BASE=/opt/tomcat' }
    its(:content) { should contain 'CATALINA_PID="$CATALINA_BASE/bin/tomcat/pid"' }
  end

  describe file('/opt/tomcat/conf/Catalina/localhost/sample.xml') do
    it { should be_file }
    it { should be_owned_by 'tomcat' }
    it { should be_grouped_into 'tomcat' }
  end

  describe file('/opt/tomcat/webapps/sample.war') do
    it { should be_file }
    it { should be_owned_by 'tomcat' }
    it { should be_grouped_into 'tomcat' }
  end

  describe file('/opt/tomcat/webapps/sample') do
    it { should be_directory }
    it { should be_owned_by 'tomcat' }
    it { should be_grouped_into 'tomcat' }
  end

  describe command('cat /opt/tomcat/conf/Catalina/localhost/sample.xml') do
    its(:stdout) { should contain('url="jdbc:mysql://db1.example.com:3306/app_test"') }
    its(:stdout) { should contain('username="app_user"') }
    its(:stdout) { should contain('password="app_pass"') }
  end

  describe command('/usr/bin/java -version') do
    its(:stderr) { should contain('1.8.0') }
    its(:exit_status) { should eq 0 }
  end

  describe command('curl http://localhost:8080/sample/') do
    its('stdout') { should match(/Sample \"Hello, World\" Application/) }
  end
end
