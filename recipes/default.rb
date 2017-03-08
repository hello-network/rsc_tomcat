#
# Cookbook Name:: rsc_tomcat
# Recipe:: default
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

# including defaults
include_recipe 'build-essential'

# override some attributes
node.override['java']['install_flavor'] = node['rsc_tomcat']['java']['flavor']
if node['rsc_tomcat']['java']['flavor'] == 'oracle'
  node.override['java']['oracle']['accept_oracle_download_terms'] = true
end

node.override['java']['jdk_version'] = node['rsc_tomcat']['java']['version']

include_recipe 'java'
include_recipe 'rsc_ros'

user 'tomcat'
group 'tomcat' do
  members 'tomcat'
  action :create
end

tomcat_install 'default' do
  version node['rsc_tomcat']['version']
  install_path node['rsc_tomcat']['home']
  exclude_docs true
  exclude_examples true
  exclude_manager false
  exclude_hostmanager false
  tomcat_user 'tomcat'
  tomcat_group 'tomcat'
end

directory "#{node['rsc_tomcat']['home']}/conf/Catalina/localhost" do
  recursive true
end

war_file = node['rsc_ros']['file'].split('/').last
# setup the default context file
template "#{node['rsc_tomcat']['home']}/conf/Catalina/localhost/#{node['rsc_tomcat']['application_name']}.xml" do
  source node['rsc_tomcat']['context_template']
  cookbook node['rsc_tomcat']['cookbook']
  variables(
    app: node['rsc_tomcat']['application_name'],
    war: "#{node['rsc_tomcat']['home']}/webapps/#{war_file}",
    database:   node['rsc_tomcat']['database']
  )
  owner 'tomcat'
  group 'tomcat'
  action :create
end

rsc_ros "#{node['rsc_tomcat']['home']}/webapps/#{war_file}" do
  storage_provider node['rsc_ros']['provider']
  access_key node['rsc_ros']['access_key']
  secret_key node['rsc_ros']['secret_key']
  bucket node['rsc_ros']['bucket']
  file node['rsc_ros']['file']
  destination "#{node['rsc_ros']['destination']}/#{war_file}"
  region node['rsc_ros']['region']
  action :download
end

execute 'war file permissions' do
  command "chown tomcat:tomcat #{node['rsc_tomcat']['home']}/webapps/#{war_file}"
  action :run
end

# install and start the tomcat service
tomcat_service 'default' do
  action [:start, :enable]
  install_path node['rsc_tomcat']['home']
  env_vars [{
    'CATALINA_OPTS' => node['rsc_tomcat']['catalina_options'],
    'CATALINA_PID' => '$CATALINA_BASE/bin/tomcat.pid' }]
  sensitive true
  tomcat_user 'tomcat'
  tomcat_group 'tomcat'
end

service 'iptable' do
  action :stop
  only_if { node['platform_family'] == 'fedora' }
end
