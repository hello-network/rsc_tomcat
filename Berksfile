site :opscode

metadata

cookbook 'collectd', github: 'rightscale-cookbooks-contrib/chef-collectd', branch: 'generalize_install_for_both_centos_and_ubuntu'
cookbook 'application_java', github: 'rightscale-services-cookbooks/application_java', ref: 'ps_mods'
cookbook 'rightscale_tag', github: 'rightscale-cookbooks/rightscale_tag'
cookbook 'tomcat', github: 'opscode-cookbooks/tomcat', ref: 'v0.15.12'

group :integration do
  cookbook 'apt', '~> 2.6.0'
  cookbook 'yum-epel', '~> 0.4.0'
 # cookbook 'curl', '~> 1.1.0'
 # cookbook 'fake', path: './test/cookbooks/fake'
 # cookbook 'rhsm', '~> 1.0.0'
end