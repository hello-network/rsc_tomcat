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

marker "recipe_start_rightscale" do
  template "rightscale_audit_entry.erb"
end


#include_recipe 'git'
#include_recipe 'database::mysql'

#override some attributes
node.override['java']['install_flavor'] = node['rsc_tomcat']['java']['flavor']
if node['rsc_tomcat']['java']['flavor']=='oracle'
  node.override['java']['oracle']['accept_oracle_download_terms']=true
end
node.override['java']['jdk_version']    = node['rsc_tomcat']['java']['version']
node.override['tomcat']['java_options'] = node['rsc_tomcat']['java']['options']
node.override['tomcat']['base_version'] = node[:rsc_tomcat][:tomcat][:version] 


# TODO: The database block in the rails block below doesn't accept node variables.
# It is a known issue and will be fixed by Opscode.
#
database_host = node['rsc_tomcat']['database']['host']
database_user = node['rsc_tomcat']['database']['user']
database_password = node['rsc_tomcat']['database']['password']
database_schema = node['rsc_tomcat']['database']['schema']
#database_adapter = node['rsc_tomcat']['database']['adapter']

application node['rsc_tomcat']['application_name'] do
  path "/home/webapps/#{node['rsc_tomcat']['application_name']}"
  owner node['tomcat']['user']
  group node['tomcat']['group']
 
  
  # Configure SCM to check out application from
  repository node['rsc_tomcat']['war']['path']
  #revision node['rsc_tomcat']['war']['revision']
  scm_provider scm_provider Chef::Provider::RemoteFile::Deploy


  #Configure Rails
  java_webapp do

    database do
      driver    'org.gjt.mm.mysql.Driver'
      host      database_host
      database  database_schema
      username  database_user
      password  database_password
    end
  end

  tomcat
 
  action :force_deploy
end