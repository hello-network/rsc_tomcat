#
# Cookbook Name:: rsc_passenger
# Recipe:: application_backend
#
# Copyright (C) 2014 RightScale, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

marker 'recipe_start_rightscale' do
  template 'rightscale_audit_entry.erb'
end

class Chef::Recipe
  include Rightscale::RightscaleTag
end

# Validate application name
RsApplicationPassenger::Helper.validate_application_name(node['rsc_passenger']['application_name'])

# Check if there is at least one load balancer in the deployment serving the application name
if find_load_balancer_servers(node, node['rsc_passenger']['application_name']).empty?
  raise "No load balancer servers found in the deployment serving #{node['rsc_passenger']['application_name']}!"
end

# Put this backend into consideration during tag queries
log 'Tagging the application server to put it into consideration during tag queries...'
machine_tag "application:active_#{node['rsc_passenger']['application_name']}=true" do
  action :create
end

remote_request_json = '/tmp/rs-haproxy_remote_request.json'

file remote_request_json do
  mode 0660
  content ::JSON.pretty_generate({
    'remote_recipe' => {
      'application_bind_ip' => RsApplicationPassenger::Helper.get_bind_ip_address(node),
      'application_bind_port' => node['rsc_passenger']['listen_port'],
      'application_server_id' => node['rightscale']['instance_uuid'],
      'pool_name' => node['rsc_passenger']['application_name'],
      'vhost_path' => node['rsc_passenger']['vhost_path'],
      'application_action' => 'attach'
    }
  })
end

# Send remote recipe request
log "Running recipe '#{node['rsc_passenger']['remote_attach_recipe']}' on all load balancers" +
 " with tags 'load_balancer:active_#{node['rsc_passenger']['application_name']}=true'..."

execute 'Attach to load balancer(s)' do
  command [
    'rs_run_recipe',
    '--name', node['rsc_passenger']['remote_attach_recipe'],
    '--recipient_tags', "load_balancer:active_#{node['rsc_passenger']['application_name']}=true",
    '--json', remote_request_json
  ]
end

file remote_request_json do
  action :delete
end
