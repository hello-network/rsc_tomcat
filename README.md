# rsc_tomcat cookbook
This cookbook is designed to work with RightScale ServerTemplates using the v14 lineage.
It is based off the [application_java](https://github.com/poise/application_java).  See that 
cookbook for details on providers and additional attributes for overrides. 

# OS Support
* Centos 6.5
* Ubuntu 12.04
* Ubuntu 14.04

# Cookbooks
* java
* tomcat

# Attributes



# Recipes
rsc_tomcat::default - installs and configures apache with your tomcat app
rsc_tomcat::tags - Adds the RightScale Tags to the Instance for the load balancer to find 
and attach
rsc_tomcat::application_backend - Attaches to the load balancer
rsc_tomcat::applicaton_backend_detach - Detaches to the load balancer
rsc_tomcat::collectd - setup monitoring using collectd

# Author
Author:: RightScale, Inc. (<ps@rightscale.com>)
