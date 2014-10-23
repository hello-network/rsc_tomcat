#
# Cookbook Name:: rsc_passenger
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


include_recipe 'git'
include_recipe 'database::mysql'

# override some passenger_apache2 attributes for our custom ruby
if node[:rsc_passenger][:passenger][:version]#.blank?
  node.override['passenger']['version']=node[:rsc_passenger][:passenger][:version]
else
  node.set['passenger'].delete('version') 
end

node.override['passenger']['gem_bin'] ="#{node['rsc_passenger']['ruby_path']}/gem"
node.override['passenger']['ruby_bin'] = "#{node['rsc_passenger']['ruby_path']}/ruby" 
#node.override['passenger']['root_path']   = %x{#{node['rsc_passenger']['ruby_path']}/gem env gemdir}.chomp!+"/gems/passenger-#{node['passenger']['version']}" 
ruby_block "update passenger root" do
  block do
    node.override['passenger']['root_path']   = %x{#{node[:passenger][:gem_bin]} env gemdir}.chomp!+"/gems/passenger-#{node['passenger']['version']}" 
  end
end
# Convert the packages list to a Hash if any of the package has version specified.
# See libraries/helper.php for the definition of `split_by_package_name_and_version` method.
application_packages = RsApplicationPassenger::Helper.split_by_package_name_and_version(node['rsc_passenger']['packages'])

# TODO: The database block in the rails block below doesn't accept node variables.
# It is a known issue and will be fixed by Opscode.
#
database_host = node['rsc_passenger']['database']['host']
database_user = node['rsc_passenger']['database']['user']
database_password = node['rsc_passenger']['database']['password']
database_schema = node['rsc_passenger']['database']['schema']

node.override['apache']['listen_ports'] = [node['rsc_passenger']['listen_port']]
# Enable Apache extended status page
Chef::Log.info "Overriding 'apache/ext_status' to true"
node.override['apache']['ext_status'] = true
# Set up application
gems = node['rsc_passenger']['gems'].split(',') if !node['rsc_passenger']['gems'].empty?
log "Installing gems: #{gems}"
precompile_assets = (!node['rsc_passenger']['precompile_assets'].empty? and node['rsc_passenger']['precompile_assets']=='true') ? true:false
application node['rsc_passenger']['application_name'] do
  path "/home/webapps/#{node['rsc_passenger']['application_name']}"
  owner node['apache']['user']
  group node['apache']['group']
  
 
  
  # Configure SCM to check out application from
  repository node['rsc_passenger']['scm']['repository']
  revision node['rsc_passenger']['scm']['revision']
  scm_provider node['rsc_passenger']['scm']['provider']
  if node['rsc_passenger']['scm']['deploy_key'] && !node['rsc_passenger']['scm']['deploy_key'].empty?
    deploy_key node['rsc_passenger']['scm']['deploy_key']
  end

  # Install application related packages
  packages application_packages
  #set the RAILS_ENV
  environment_name node['rsc_passenger']['environment']
  # Application migration step
  if node['rsc_passenger']['migration_command'] && !node['rsc_passenger']['migration_command'].empty?
    migrate true
    migration_command node['rsc_passenger']['migration_command']
  end

  #Configure Rails
  rails  do
    gems gems
   # bundle_options ""
    bundler_deployment true
    precompile_assets precompile_assets
    database do
      host database_host
      database database_schema
      username database_user
      password database_password
    end
  end

  # Configure Apache and mod_php to run application by creating virtual host
  passenger_apache2 do
    #cookbook 'rsc_passenger'
    webapp_template 'web_app.conf.erb'
  end
end