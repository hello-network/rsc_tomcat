marker 'recipe_start_rightscale' do
  template 'rightscale_audit_entry.erb'
end

class Chef::Recipe
  include Rightscale::RightscaleTag
end

# Validate application name
RsApplicationTomcat::Helper.validate_application_name(app_name)
node['rsc_tomcat']['application_pool_list'].split(',').each do |app_name|
# Put this backend out of consideration during tag queries
log 'Tagging the application server to take it out of consideration during tag queries...'
machine_tag "application:active_#{app_name}=false" do
  action :create
end

# Send remote recipe request
log "Running recipe '#{node['rsc_tomcat']['remote_detach_recipe']}' on all load balancers" +
" with tags 'load_balancer:active_#{app_name}=true'..."

remote_recipe "HAProxy Frontend - chef" do
  tags "load_balancer:active_#{app_name}=true"
  attributes( {
      'APPLICATION_SERVER_ID' => "text:#{node['rightscale']['instance_uuid']}",
      'POOL_NAME' => "text:#{app_name}",
      'APPLICATION_ACTION' => "text:detach"})
  action :run
end
end
