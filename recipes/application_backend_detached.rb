marker 'recipe_start_rightscale' do
  template 'rightscale_audit_entry.erb'
end

class Chef::Recipe
  include Rightscale::RightscaleTag
end

# Validate application name
RsApplicationPhp::Helper.validate_application_name(node['rs-application_php']['application_name'])

# Put this backend out of consideration during tag queries
log 'Tagging the application server to take it out of consideration during tag queries...'
machine_tag "application:active_#{node['rs-application_php']['application_name']}=false" do
  action :create
end

# Send remote recipe request
log "Running recipe '#{node['rs-application_php']['remote_detach_recipe']}' on all load balancers" +
" with tags 'load_balancer:active_#{node['rs-application_php']['application_name']}=true'..."

remote_recipe "HAProxy Frontend - chef" do
  tags "load_balancer:active_#{node['rs-application_php']['application_name']}=true"
  attributes( {
      'APPLICATION_SERVER_ID' => "text:#{node['rightscale']['instance_uuid']}",
      'POOL_NAME' => "text:#{node['rs-application_php']['application_name']}",
      'APPLICATION_ACTION' => "text:detach"})
  action :run
end
