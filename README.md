# rsc_passenger cookbook
This cookbook is designed to work with RightScale ServerTemplates using the v14 lineage.
It is based off the [application_ruby](https://github.com/poise/application_ruby).  See that 
cookbook for details on providers and additional attributes for overrides. 

# Requirements
The cookbook assumes ruby is installed or you can use the 
[rsc_ruby](https://github.com/RightScale-Services-Cookbooks/rsc_ruby.git) cookbook 
or your own method to install ruby

# Attributes

# Recipes
rsc_passenger::default - installs and configures apache with your rails/passenger app
rsc_passenger::tags - Adds the RightScale Tags to the Instance for the load balancer to find 
and attach
rsc_passenger::application_backend - Attaches to the load balancer
rsc_passenger::applicaton_backend_detach - Detaches to the load balancer

# Author
Author:: RightScale, Inc. (<ps@rightscale.com>)
