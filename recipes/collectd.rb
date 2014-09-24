#
# Cookbook Name:: rsc_passenger
# Recipe:: collectd
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

chef_gem 'chef-rewind'
require 'chef/rewind'

if node['rightscale'] && node['rightscale']['instance_uuid']
  node.override['collectd']['fqdn'] = node['rightscale']['instance_uuid']
end

log 'Setting up monitoring for apache...'

# On CentOS the Apache collectd plugin is installed separately
package 'collectd-apache' do
  only_if { node['platform'] =~ /redhat|centos/ }
end

include_recipe 'collectd::default'

# The 'collectd::default' recipe attempts to delete collectd plugins that were not
# created during the same runlist as this recipe. Some common plugins are installed
# as a part of base install which runs in a different runlist. This resource
# will safeguard the base plugins from being removed.
rewind 'ruby_block[delete_old_plugins]' do
  action :nothing
end

# Set up apache monitoring
collectd_plugin 'apache' do
  options(
    'URL' => "http://localhost:#{node['rsc_passenger']['listen_port']}/server-status?auto"
  )
end

# Set up apache process monitoring
cookbook_file "#{node['collectd']['plugin_dir']}/apache_ps" do
  mode 0755
  source 'apache_ps'
end

collectd_plugin 'apache_ps' do
  template 'apache_ps.conf.erb'
  cookbook 'rsc_passenger'
  options({
    :collectd_lib => node['collectd']['plugin_dir'],
    :instance_uuid => node['rightscale']['instance_uuid'],
    :apache_user => node['apache']['user']
  })
end
