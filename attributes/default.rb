#
# Cookbook Name:: rs-services_rails
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

# Packages to install
default['rs-services_rails']['packages'] = []

# Application listen port
default['rs-services_rails']['listen_port'] = 8080

# The source control provider
default['rs-services_rails']['scm']['provider'] = 'git'

# The repository to checkout the code from
default['rs-services_rails']['scm']['repository'] = nil

# The revision of application code to checkout from the repository
default['rs-services_rails']['scm']['revision'] = 'master'

# The private key to access the repository via SSH
default['rs-services_rails']['scm']['deploy_key'] = nil

# The name of the application
default['rs-services_rails']['application_name'] = "myapp"

# The root of the application
default['rs-services_rails']['app_root'] = '/'
default['rs-services_rails']['precompile_assets'] = 'false'

# The command used to perform application migration
#
# @example: To import database contents from the dump file for a LAMP server, the following can be set as the
# migration command:
#
#   node.override['rs-services_rails']['migration_command'] =
#     "gunzip < #{dump_file}.sql.gz | mysql -u#{database_username} -p#{database_password} #{schema_name}"
#
default['rs-services_rails']['migration_command'] = nil

# Database configuration

# The database provider
default['rs-services_rails']['database']['provider'] = 'mysql'

# The database host
default['rs-services_rails']['database']['host'] = 'localhost'

# The database username
default['rs-services_rails']['database']['user'] = nil

# The database password
default['rs-services_rails']['database']['password'] = nil

# The database schema name
default['rs-services_rails']['database']['schema'] = nil

# Remote recipe to attach application server to load balancer
default['rs-services_rails']['remote_attach_recipe'] = 'rs-haproxy::frontend'

# Remote recipe to detach application server from load balancer
default['rs-services_rails']['remote_detach_recipe'] = 'rs-haproxy::frontend'