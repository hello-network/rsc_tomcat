#
# Cookbook Name:: rs-services_rails
# Recipe:: application_backend_detached
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
RsApplicationPhp::Helper.validate_application_name(node['rs-services_rails']['application_name'])

# Put this backend out of consideration during tag queries
log 'Tagging the application server to take it out of consideration during tag queries...'
machine_tag "application:active_#{node['rs-services_rails']['application_name']}=false" do
  action :create
end

remote_request_json = '/tmp/rs-haproxy_remote_request.json'

file remote_request_json do
  mode 0660
  content ::JSON.pretty_generate({
    'remote_recipe' => {
      'application_server_id' => node['rightscale']['instance_uuid'],
      'pool_name' => node['rs-services_rails']['application_name'],
      'application_action' => 'detach'
    }
  })
end

# Send remote recipe request
log "Running recipe '#{node['rs-services_rails']['remote_detach_recipe']}' on all load balancers" +
" with tags 'load_balancer:active_#{node['rs-services_rails']['application_name']}=true'..."

execute 'Detach from load balancer(s)' do
  command [
    'rs_run_recipe',
    '--name', node['rs-services_rails']['remote_detach_recipe'],
    '--recipient_tags', "load_balancer:active_#{node['rs-services_rails']['application_name']}=true",
    '--json', remote_request_json
  ]
end

file remote_request_json do
  action :delete
end
