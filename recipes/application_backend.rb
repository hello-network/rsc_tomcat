marker 'recipe_start_rightscale' do
  template 'rightscale_audit_entry.erb'
end

class Chef::Recipe
  include Rightscale::RightscaleTag
end

# Validate application name
RsApplicationPhp::Helper.validate_application_name(node['rs-application_php']['application_name'])

# Check if there is at least one load balancer in the deployment serving the application name
if find_load_balancer_servers(node, node['rs-application_php']['application_name']).empty?
  raise "No load balancer servers found in the deployment serving #{node['rs-application_php']['application_name']}!"
end

# Put this backend into consideration during tag queries
log 'Tagging the application server to put it into consideration during tag queries...'
machine_tag "application:active_#{node['rs-application_php']['application_name']}=true" do
  action :create
end


# Send remote recipe request
log "Running recipe '#{node['rs-application_php']['remote_attach_recipe']}' on all load balancers" +
 " with tags 'load_balancer:active_#{node['rs-application_php']['application_name']}=true'..."

remote_recipe "HAProxy Frontend - chef" do
  tags "load_balancer:active_#{node['rs-application_php']['application_name']}=true"
  attributes( {'APPLICATION_BIND_IP' => "text:#{node['cloud']["private_ips"][0]}",
      'APPLICATION_BIND_PORT' => "text:#{node['rs-application_php']['listen_port']}",
      'APPLICATION_SERVER_ID' => "text:#{node['rightscale']['instance_uuid']}",
      'POOL_NAME' => "text:#{node['rs-application_php']['application_name']}",
      'VHOST_PATH' => "text:#{node['rs-application_php']['vhost_path']}",
      'APPLICATION_ACTION' => "text:attach"})
  action :run
end
