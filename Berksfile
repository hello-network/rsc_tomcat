site :opscode

metadata

cookbook 'collectd', github: 'rightscale-cookbooks-contrib/chef-collectd', branch: 'generalize_install_for_both_centos_and_ubuntu'
cookbook 'application_java', github: 'rightscale-services-cookbooks/application_java', ref: 'ps_mods'
#cookbook 'application_java', path: '../application_java' #github: 'opscode-cookbooks/tomcat', ref: 'v0.15.12'
cookbook 'rightscale_tag', github: 'rightscale-cookbooks/rightscale_tag'
cookbook 'rs-base' ,github: 'rightscale-cookbooks/rs-base'
cookbook 'tomcat', github: 'rightscale-services-cookbooks/tomcat', ref: 'ps_mods'
#cookbook 'tomcat', path: '../tomcat'

group :integration do
  cookbook 'apt', '~> 2.6.0'
  cookbook 'yum-epel', '~> 0.4.0'
 # cookbook 'curl', '~> 1.1.0'
 # cookbook 'fake', path: './test/cookbooks/fake'
 # cookbook 'rhsm', '~> 1.0.0'
end