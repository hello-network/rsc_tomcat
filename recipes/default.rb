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

#including defaults
include_recipe 'apt'
include_recipe 'build-essential'

#override some attributes
node.override['java']['install_flavor'] = node['rsc_tomcat']['java']['flavor']
if node['rsc_tomcat']['java']['flavor']=='oracle'
  node.override['java']['oracle']['accept_oracle_download_terms']=true
end

node.force_override['java']['jdk_version']    = node['rsc_tomcat']['java']['version']
node.force_override['tomcat']['java_options'] = node['rsc_tomcat']['java']['options']
node.override['tomcat']['port'] = node['tomcat']['listen_port']

include_recipe 'java'

# TODO: The database block in the java_webapp block below doesn't accept node variables.
# It is a known issue and will be fixed by Opscode.
#
database_host = node['rsc_tomcat']['database']['host']
database_user = node['rsc_tomcat']['database']['user']
database_password = node['rsc_tomcat']['database']['password']
database_schema = node['rsc_tomcat']['database']['schema']
#database_adapter = node['rsc_tomcat']['database']['adapter']

#decide how to get file. 
# if the file is remote, download it and install from local path
if node['rsc_tomcat']['war']['path'] =~ /^http/
  repository= "#{Chef::Config[:file_cache_path]}/#{node['rsc_tomcat']['war']['path'].split('/').last}"
  remote_file repository do
    source node['rsc_tomcat']['war']['path']
  end

else
  repository = node['rsc_tomcat']['war']['path']

end

application node['rsc_tomcat']['application_name'] do
  path "/home/webapps/#{node['rsc_tomcat']['application_name']}"
  owner node['tomcat']['user']
  group node['tomcat']['group']
 
  
  # Configure SCM to check out application from
  repository repository
  #revision node['rsc_tomcat']['war']['revision']
  scm_provider Chef::Provider::File::Deploy  


  #Configure Tomcat web app
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
