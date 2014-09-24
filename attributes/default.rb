#
# Cookbook Name:: rsc_passenger
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

#ruby config
#default['passenger']['ruby_bin'] = '/usr/bin/ruby'
#default['passenger']['root_path']   = "/usr/share/ruby/gems/1.9.1/gems/passenger-#{passenger['version']}"

# Packages to install
default['rsc_passenger']['packages'] = []

# Application listen port
default['rsc_passenger']['listen_port'] = 8080

# The source control provider
default['rsc_passenger']['scm']['provider'] = 'git'

# The repository to checkout the code from
default['rsc_passenger']['scm']['repository'] = nil

# The revision of application code to checkout from the repository
default['rsc_passenger']['scm']['revision'] = 'master'

# The private key to access the repository via SSH
default['rsc_passenger']['scm']['deploy_key'] = nil

# The name of the application
default['rsc_passenger']['application_name'] = "myapp"

# The root of the application
default['rsc_passenger']['app_root'] = '/'
default['rsc_passenger']['precompile_assets'] = 'false'

# The command used to perform application migration
#
# @example: To import database contents from the dump file for a LAMP server, the following can be set as the
# migration command:
#
#   node.override['rsc_passenger']['migration_command'] =
#     "gunzip < #{dump_file}.sql.gz | mysql -u#{database_username} -p#{database_password} #{schema_name}"
#
default['rsc_passenger']['migration_command'] = nil

# Database configuration

# The database provider
default['rsc_passenger']['database']['provider'] = 'mysql'

# The database host
default['rsc_passenger']['database']['host'] = 'localhost'

# The database username
default['rsc_passenger']['database']['user'] = nil

# The database password
default['rsc_passenger']['database']['password'] = nil

# The database schema name
default['rsc_passenger']['database']['schema'] = nil

# Remote recipe to attach application server to load balancer
default['rsc_passenger']['remote_attach_recipe'] = 'rs-haproxy::frontend'

# Remote recipe to detach application server from load balancer
default['rsc_passenger']['remote_detach_recipe'] = 'rs-haproxy::frontend'