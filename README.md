# rsc_tomcat cookbook
This cookbook is designed to work with RightLink 10, and Chef Server as of version 1.3.0.
Previous versions worked with the v14 server template, but 1.3.0 is a new version for chef server.
It is based off the [application_java](https://github.com/poise/application_java).  See that
cookbook for details on providers and additional attributes for overrides.

# Chef
- Support Chef 11.6 or later.

# OS Support
* Ubuntu 14.04
* Centos 6.6

# Cookbooks
the application_java and tomcat cookbooks below have been updated to support tomcat7.  
* java from https://github.com/agileorbit-cookbooks/java
* application_java from rightscale-services-cookbooks/application_java, branch: ps_mods
* tomcat from rightscale-services-cookbooks/tomcat, branch: ps_mods

# Attributes
* `node['rsc_tomcat']['listen_port']` - 'The port to use for the application to bind. Example: 8080'
* `node['rsc_tomcat']['war']['path']` - 'URL of WAR file '
* `node['rsc_tomcat']['application_name']` - 'The name of the application.'
* `node['rsc_tomcat']['app_root']` - 'Application Root' default: /home/webapps
* `node['rsc_tomcat']['vhost_path']` - 'Virtual Host Name/Path'
* `node['rsc_tomcat']['bind_network_interface']` - 'Application Bind Network Interface'
* `node['rsc_tomcat']['database']['host']` - 'Database Host'
* `node['rsc_tomcat']['database']['user']` - 'MySQL Application Username'
* `node['rsc_tomcat']['database']['password']` - 'MySQL Application Password'
* `node['rsc_tomcat']['database']['schema']` - 'MySQL Database Name'
* `node['rsc_tomcat']['database']['port']` - 'MySQL Database Port'
* `node['rsc_tomcat']['database']['max_active']` - 'Connection Pool Max Active Connections'
* `node['rsc_tomcat']['database']['max_idle']` - 'Connection Pool Max Idle Connections'
* `node['rsc_tomcat']['database']['max_wait']` - 'Connection Pool Max Wait Connections'
* `node['rsc_tomcat']['java']['version']` - 'JAVA JDK version to install'
* `node['rsc_tomcat']['java']['flavor']` - 'JVM Flavor to install '
* `node['rsc_tomcat']['java']['options']` - 'Tomcat JAVA Options'
* `node['tomcat']['base_version']` - Tomcat Version
* `node['tomcat']['catalina_options']` - 'Tomcat Catalina Options'
* `node['tomcat']['install_method']` -  'method used to install tomcat. '
* `node['tomcat']['tar_version']` - 'Tomcat Tar Version'


# Recipes
rsc_tomcat::default - installs and configures apache with your tomcat app
rsc_tomcat::tags - Adds the RightScale Tags to the Instance for the load balancer to find
and attach
rsc_tomcat::application_backend - Attaches to the load balancer
rsc_tomcat::applicaton_backend_detach - Detaches to the load balancer
rsc_tomcat::collectd - setup monitoring using collectd

# Testing
The test suite is kitchen for centos 6.5, cento 7.1 ubunut 12.04, ubuntu 14.04

* gem install bundle
* bundle
* bundle exec kitchen test

# Author
Author:: RightScale, Inc. (<ps@rightscale.com>)
