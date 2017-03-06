require_relative 'spec_helper'

describe 'rsc_tomcat::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node|
      node.set['rsc_tomcat']['application_name'] = 'sample'
      node.set['rsc_tomcat']['listen_port'] = '8080'
      node.set['rsc_tomcat']['bind_network_interface'] = 'private'
      node.set['rsc_tomcat']['vhost_path'] = 'www.example.com'
      node.set['rsc_ros']['file'] = 'sample/sample.war'
      node.set['rsc_ros']['provider'] = 'aws'
      node.set['rsc_ros']['access_key'] = 'abc123'
      node.set['rsc_ros']['secret_key'] = 'secret'
      node.set['rsc_ros']['bucket'] = 'sample'
      node.set['rsc_ros']['destination'] = '/opt/tomcat/webapps'
      node.set['rsc_ros']['region'] = 'us-east-1'
      node.set['rightscale']['refresh_token'] = '123456abcdef'
      node.set['rightscale']['api_url'] = 'https://us-3.rightscale.com'
    end.converge(described_recipe)
  end
  let(:node) { chef_run.node }

  it 'includes install recipe' do
    expect(chef_run).to include_recipe('build-essential')
    expect(chef_run).to include_recipe('java')
    expect(chef_run).to include_recipe('rsc_ros')
  end

  it 'adds tomcat user' do
    expect(chef_run).to create_user('tomcat')
  end

  it 'adds tomcat group' do
    expect(chef_run).to create_group('tomcat')
  end

  it 'installs tomcat' do
    expect(chef_run).to install_tomcat_install('default')
  end

  it 'creates context directory' do
    expect(chef_run).to create_directory('/opt/tomcat/conf/Catalina/localhost')
  end

  it 'creates context.xml' do
    expect(chef_run).to create_template('/opt/tomcat/conf/Catalina/localhost/sample.xml')
  end

  it 'downloads war file' do
    expect(chef_run).to download_rsc_ros('/opt/tomcat/webapps/sample.war')
  end

  it 'execute chmod' do
    expect(chef_run).to run_execute('war file permissions')
  end

  it 'enable tomcat service' do
    expect(chef_run).to enable_tomcat_service('default')
  end

  it 'start tomcat service' do
    expect(chef_run).to start_tomcat_service('default')
  end
end
