site :opscode

metadata

cookbook 'collectd', github: 'rightscale-cookbooks-contrib/chef-collectd', branch: 'generalize_install_for_both_centos_and_ubuntu'
cookbook 'application_java', github: 'rightscale-services-cookbooks/application_java', ref: 'ps_mods'
#cookbook 'application_java', path: '../application_java' #github: 'opscode-cookbooks/tomcat', ref: 'v0.15.12'
cookbook 'rightscale_tag', github: 'rightscale-cookbooks/rightscale_tag', branch: 'v1.2.1'
cookbook 'machine_tag', github: 'rightscale-cookbooks/machine_tag', branch: 'v1.2.1'
cookbook 'rs-base', github: 'rightscale-cookbooks/rs-base', branch: 'upgrade-rightscale-tag'
cookbook 'tomcat', github: 'rightscale-services-cookbooks/tomcat', ref: 'ps_mods'
cookbook 'rsc_remote_recipe', github: 'rightscale-services-cookbooks/rsc_remote_recipe', tag: 'v10.0.1'
#cookbook 'tomcat', path: '../tomcat'

group :integration do
  cookbook 'apt', '~> 2.9.2'
  cookbook 'yum-epel', '~> 0.6.6'
end
