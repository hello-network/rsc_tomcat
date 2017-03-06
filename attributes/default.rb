#
# Cookbook Name:: rsc_tomcat
# Attribute:: default
#
# Copyright (C) 2013 RightScale, Inc.
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
default['apt']['compile_time_update'] = true
default['build-essential']['compile_time'] = true

# Default Listen Interface
default['rsc_tomcat']['bind_network_interface'] = 'private'

# Application listen port
default['rsc_tomcat']['listen_port'] = 8080

# The source control provider
default['rsc_tomcat']['scm']['provider'] = 'git'

# The repository to checkout the code from
default['rsc_tomcat']['scm']['repository'] = nil

# The revision of application code to checkout from the repository
default['rsc_tomcat']['scm']['revision'] = 'master'

# The private key to access the repository via SSH
default['rsc_tomcat']['scm']['deploy_key'] = nil

# The name of the application
default['rsc_tomcat']['application_name'] = 'myapp'

# The root of the application
default['rsc_tomcat']['app_root'] = '/home/webapps'

# Database configuration
# The database provider
default['rsc_tomcat']['database']['provider'] = 'mysql'

# The database host
default['rsc_tomcat']['database']['host'] = 'localhost'

# The database username
default['rsc_tomcat']['database']['user'] = nil

# The database password
default['rsc_tomcat']['database']['password'] = nil

# The database schema name
default['rsc_tomcat']['database']['schema'] = nil
default['rsc_tomcat']['database']['port'] = 3306
default['rsc_tomcat']['database']['max_active'] = 100
default['rsc_tomcat']['database']['max_idle'] = 100
default['rsc_tomcat']['database']['max_wait'] = 30_000

# The database adapter/driver name
default['rsc_tomcat']['database']['driver'] = 'org.gjt.mm.mysql.Driver'

# Remote recipe to attach application server to load balancer
default['rsc_tomcat']['remote_attach_recipe'] = 'rs-haproxy::frontend'

# Remote recipe to detach application server from load balancer
default['rsc_tomcat']['remote_detach_recipe'] = 'rs-haproxy::frontend'

# context template source, use override to use context from another cookbook
default['rsc_tomcat']['context_template'] = 'context.xml.erb'
default['rsc_tomcat']['cookbook'] = 'rsc_tomcat'
# tomcat configuration

default['rsc_tomcat']['version'] = '8.0.36'
default['rsc_tomcat']['home'] = '/opt/tomcat'
default['rsc_tomcat']['catalina_options'] = '-Xmx128M -Djava.awt.headless=true'

# java configuration
default['rsc_tomcat']['java']['version'] = '8'
default['rsc_tomcat']['java']['flavor'] = 'openjdk'

# rsc_ros attributes
default['rsc_ros']['destination'] = '/opt/tomcat/webapps'
