require_relative 'spec_helper'

describe 'rsc_tomcat::tags' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node|
      node.set['rsc_tomcat']['application_name'] = 'sample'
      node.set['rsc_tomcat']['listen_port'] = '8080'
      node.set['cloud']['private_ips'] = ['1.2.3.4']
      node.set['rsc_tomcat']['bind_network_interface'] = 'private'
      node.set['rsc_tomcat']['vhost_path'] = 'www.example.com'
      # node.set['rsc_tomcat']['war']['path'] = 'https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war'
      # node.set['rightscale']['refresh_token'] = '123456abcdef'
      # node.set['rightscale']['api_url'] = 'https://us-3.rightscale.com'
    end.converge(described_recipe)
  end
  let(:node) { chef_run.node }

  it 'includes install recipe' do
    expect(chef_run).to include_recipe('rightscale_tag::default')
  end

  it 'creates rightscale tags' do
    expect(chef_run).to create_rightscale_tag_application('sample')
  end
end
