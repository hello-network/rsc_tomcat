#
# Cookbook Name:: rsc_tomcat
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

version = node['tomcat']['base_version']

chef_gem 'chef-rewind'
require 'chef/rewind'

if node['rightscale'] && node['rightscale']['instance_uuid']
  node.override['collectd']['fqdn'] = node['rightscale']['instance_uuid']
end

log 'Setting up monitoring for tomcat...'

# On CentOS the Apache collectd plugin is installed separately
# package 'collectd-java' do
#  only_if { node['platform'] =~ /redhat|centos/ }
# end

include_recipe 'collectd::default'

# The 'collectd::default' recipe attempts to delete collectd plugins that were not
# created during the same runlist as this recipe. Some common plugins are installed
# as a part of base install which runs in a different runlist. This resource
# will safeguard the base plugins from being removed.
rewind 'ruby_block[delete_old_plugins]' do
  action :nothing
end

# Installing and configuring collectd for tomcat
cookbook_file "#{node['tomcat']['lib_dir']}/collectd.jar" do
  source 'collectd.jar'
  mode '0644'
end

# Add collectd support to tomcat.conf
bash 'Add collectd to tomcat configuration file' do
  flags '-ex'
  code <<-EOH
      echo 'CATALINA_OPTS=\"\$CATALINA_OPTS -Djcd.host=#{node['rightscale']['instance_uuid']} -Djcd.instance=tomcat#{version} -Djcd.dest=udp://#{node['rightscale']['sketchy']}:3011 -Djcd.tmpl=javalang,tomcat -javaagent:#{node['tomcat']['lib_dir']}/collectd.jar\"' >> /etc/tomcat#{version}/tomcat#{version}.conf
    EOH
end
