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
include_recipe 'apt'
include_recipe 'build-essential'

# override some attributes
node.override['java']['install_flavor'] = node['rsc_tomcat']['java']['flavor']
if node['rsc_tomcat']['java']['flavor'] == 'oracle'
  node.override['java']['oracle']['accept_oracle_download_terms'] = true
end

node.override['java']['jdk_version'] = node['rsc_tomcat']['java']['version']

include_recipe 'java'

user "tomcat"
group "tomcat" do
  members 'tomcat'
  action :create
end

tomcat_install 'default' do
  version node["rsc_tomcat"]["version"]
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

# setup the default context file
template "#{node['rsc_tomcat']['home']}/conf/Catalina/localhost/#{node['rsc_tomcat']['application_name']}.xml" do
  source node["rsc_tomcat"]["context_template"]
  cookbook node["rsc_tomcat"]["cookbook"]
  variables(
    app: node['rsc_tomcat']['application_name'],
    war: "#{node["rsc_tomcat"]["home"]}/webapps/#{node['rsc_tomcat']['war']['path'].split('/').last}",
    database:   node["rsc_tomcat"]["database"],
  )
  owner "tomcat"
  group "tomcat"
  action :create
end

#download file and place it in the webapps dir
if !node['rsc_tomcat']['war']['path'].empty? && node['rsc_tomcat']['war']['path'] =~ /^http/
  remote_file "#{node["rsc_tomcat"]["home"]}/webapps/#{node['rsc_tomcat']['war']['path'].split('/').last}" do
    source node['rsc_tomcat']['war']['path']
  end
end

# install and start the tomcat service
tomcat_service 'default' do
  action [:start, :enable]
  install_path node['rsc_tomcat']['home']
  sensitive true
  tomcat_user 'tomcat'
  tomcat_group 'tomcat'
end

# application node['rsc_tomcat']['application_name'] do
#   path "#{node['rsc_tomcat']['app_root']}/#{node['rsc_tomcat']['application_name']}"
#   owner node['tomcat']['user']
#   group node['tomcat']['group']
#
#   # Configure SCM to check out application from
#   repository repository
#   # revision node['rsc_tomcat']['war']['revision']
#   scm_provider Chef::Provider::File::Deploy
#
#   # Configure Tomcat web app
#   java_webapp do
#     database do
#       driver     database_adapter
#       host       database_host
#       database   database_schema
#       username   database_user
#       password   database_password
#       port 	     database_port
#       max_active database_max_active
#       max_idle   database_max_idle
#       max_wait   database_max_wait
#     end
#   end
#
#   tomcat
#
#   action :force_deploy
# end
