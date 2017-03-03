# rsc_tomcat cookbook
This cookbook is designed to work with RightLink 10, and Chef Server as of version 1.3.0.
Previous versions worked with the v14 server template, but 1.3.0 is a new version for chef server.  
---
The RightScale API is used to run recipes on the HaProxy load balancer.  

# Chef
- Support Chef 12 or later.

# OS Support
* Ubuntu 14.04, 16.04
* Centos 6.8, 7.2

# Cookbooks
the application_java and tomcat cookbooks below have been updated to support tomcat7.  
* [java](https://github.com/agileorbit-cookbooks/java)
* [rsc_remote_recipe](https://github.com/rightscale-services-cookbooks/rsc_remote_recipe)
* [rsc_ros](https://github.com/rightscale-services-cookbooks/rsc_ros)

# Attributes
* `node['rightscale']['refresh_token']` - 'The RightScale refresh token.  Used to run recipes on the HaProxy server'
* `node['rightscale']['api_url']` - 'The Rightscale API endpoint. Used to run recipes on the HaProxy Server'
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
* `node['rsc_tomcat']['version']` - Tomcat Version
* `node['rsc_tomcat']['home']` - Tomcat Install Location
* `node['rsc_tomcat']['catalina_options']` - 'Tomcat Catalina Options'


# Recipes
rsc_tomcat::default - installs and configures apache with your tomcat app
rsc_tomcat::tags - Adds the RightScale Tags to the Instance for the load balancer to find
and attach
rsc_tomcat::application_backend - Attaches to the load balancer.  Use the Rightscale API to execute recipes on the HaProxy Server.
rsc_tomcat::applicaton_backend_detach - Detaches to the load balancer Use the Rightscale API to execute recipes on the HaProxy Server.

# Testing
The test suite is kitchen for centos 6.8, cento 7.2 ubunut 14.04, ubuntu 16.04

* gem install bundle
* bundle
* bundle exec kitchen test

# Author
Author:: RightScale, Inc. (<ps@rightscale.com>)
