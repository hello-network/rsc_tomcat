# rsc_tomcat cookbook
This cookbook is designed to work with RightScale ServerTemplates using the v14 lineage.
It is based off the [application_java](https://github.com/poise/application_java).  See that 
cookbook for details on providers and additional attributes for overrides. 

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
* `node['rsc_tomcat']['app_root']` - 'Application Root'
* `node['rsc_tomcat']['vhost_path']` - 'Virtual Host Name/Path'
* `node['rsc_tomcat']['bind_network_interface']` - 'Application Bind Network Interface'
* `node['rsc_tomcat']['database']['host']` - 'Database Host'
* `node['rsc_tomcat']['database']['user']` - 'MySQL Application Username'
* `node['rsc_tomcat']['database']['password']` - 'MySQL Application Password'
* `node['rsc_tomcat']['database']['schema']` - 'MySQL Database Name'
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

# Author
Author:: RightScale, Inc. (<ps@rightscale.com>)
