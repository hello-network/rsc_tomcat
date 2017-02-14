#
# Cookbook Name:: rsc_tomcat
# Recipe:: tags
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

include_recipe 'rightscale_tag::default'

# Validate application name
RsApplicationTomcat::Helper.validate_application_name(node['rsc_tomcat']['application_name'])

# Set up application server tags
rightscale_tag_application node['rsc_tomcat']['application_name'] do
  bind_ip_address RsApplicationTomcat::Helper.get_bind_ip_address(node)
  bind_port node['rsc_tomcat']['listen_port'].to_i
  vhost_path node['rsc_tomcat']['vhost_path']
  action :create
end
