#
# Cookbook Name:: rs-services_rails
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

package "ruby19"

# Convert the packages list to a Hash if any of the package has version specified.
# See libraries/helper.php for the definition of `split_by_package_name_and_version` method.
application_packages = RsApplicationRails::Helper.split_by_package_name_and_version(node['rs-services_rails']['packages'])

# TODO: The database block in the php block below doesn't accept node variables.
# It is a known issue and will be fixed by Opscode.
#
database_host = node['rs-services_rails']['database']['host']
database_user = node['rs-services_rails']['database']['user']
database_password = node['rs-services_rails']['database']['password']
database_schema = node['rs-services_rails']['database']['schema']

node.override['apache']['listen_ports'] = [node['rs-services_rails']['listen_port']]

# Enable Apache extended status page
Chef::Log.info "Overriding 'apache/ext_status' to true"
node.override['apache']['ext_status'] = true
# Set up application
application node['rs-services_rails']['application_name'] do
  path "/home/webapps/#{node['rs-services_rails']['application_name']}"
  owner node['apache']['user']
  group node['apache']['group']

  # Configure SCM to check out application from
  repository node['rs-services_rails']['scm']['repository']
  revision node['rs-services_rails']['scm']['revision']
  scm_provider node['rs-services_rails']['scm']['provider']
  if node['rs-services_rails']['scm']['deploy_key'] && !node['rs-services_rails']['scm']['deploy_key'].empty?
    deploy_key node['rs-services_rails']['scm']['deploy_key']
  end

  # Install application related packages
  packages application_packages
  #set the RAILS_ENV
  environment_name node['rs-services_rails']['environment']
  # Application migration step
  if node['rs-services_rails']['migration_command'] && !node['rs-services_rails']['migration_command'].empty?
    migrate true
    migration_command node['rs-services_rails']['migration_command']
  end


  #Configure Rails
  rails  do
    database do
      host database_host
      database database_schema
      username database_user
      password database_password
    end
  end

  # Configure Apache and mod_php to run application by creating virtual host
  passenger_apache2 do
    #cookbook 'rs-services_rails'
    webapp_template 'web_app.conf.erb'
  end
end