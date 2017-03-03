require_relative 'spec_helper'

describe 'rsc_tomcat::application_backend_detached' do
  before {

  }
  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node|
      node.set['rsc_tomcat']['application_name'] = 'sample'
      node.set['rsc_tomcat']['remote_attach_recipe'] = 'rs-haproxy::frontend'
      node.set['cloud']['provider'] = 'vagrant'
      node.set['rightscale']['instance_uuid'] = '111111111'
    end.converge(described_recipe)
  end
  let(:node) { chef_run.node }

  it "log tagging the application" do
    expect(chef_run).to write_log('Tagging the application server to take it out of consideration during tag queries...')
  end

  it "log running recipe" do
    expect(chef_run).to write_log('Running recipe \'rs-haproxy::frontend\' on all load balancers with tags \'load_balancer:active_sample=true\'...')
  end

  it "creates machine_tag" do
    expect(chef_run).to create_machine_tag("application:active_sample=false")
  end

  it "runs remote_recipe" do
    expect(chef_run).to run_remote_recipe('HAProxy Frontend - chef')
  end
end
