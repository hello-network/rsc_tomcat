require_relative 'spec_helper'


describe 'rsc_tomcat::application_backend' do
  before do
  allow(RsApplicationTomcat::Helper).to receive(:find_load_balancer_servers).with(node, 'sample').and_return({"a"=>"b"})
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['rsc_tomcat']['application_name'] = 'sample'
      node.set['rsc_tomcat']['remote_attach_recipe'] = 'rs-haproxy::frontend'
      node.set['cloud']['provider'] = 'vagrant'
    end.converge(described_recipe)
  end
  let(:node) { chef_run.node }

  it 'log Tagging the application' do
    expect(chef_run).to_not write_log('No load balancer servers found in the deployment serving sample!')
  end

  it 'log Running recipe ' do
    expect(chef_run).to write_log("Running recipe 'rs-haproxy::frontend' on all load balancers" \
        " with tags 'load_balancer:active_sample=true'...")
  end

  it 'creates machine_tag' do
    expect(chef_run).to create_machine_tag('application:active_sample=true')
  end

  it 'runs remote_recipe' do
    expect(chef_run).to run_remote_recipe('HAProxy Frontend - chef')
  end
end
