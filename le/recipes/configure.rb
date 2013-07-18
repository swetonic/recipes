#
# Cookbook Name:: le
# Recipe:: configure
#

#follow_paths = [
#  "/var/log/syslog",
#  "/var/log/auth.log",
#  "/var/log/daemon.log"
#]

#(node[:applications] || []).each do |app_name, app_info|
#  follow_paths << "/var/log/nginx/#{app_name}.access.log"
#end

follow_paths = []

if node[:environment][:name] == "production"

  # only register and monitor production
  execute "le register --account-key" do
    command "le register --account-key #{node[:le_api_key]}"
    action :run
    not_if { File.exists?('/etc/le/config') } 
  end

  # pentaho logs on utility instance named sidekiq
  if ((node[:instance_role] == 'util') && (node[:name] =~ /^sidekiq$/))
    follow_paths << "/home/deploy/pentaho.log"
  elsif (node[:instance_role] =~ /^app/)
    # all other app instances log environment log and nginx logs
    follow_paths << "/data/main/current/log/#{node[:environment][:name]}.log"
    follow_paths << "/var/log/nginx/main.access.log"
  end
else
  # if (node[:instance_role] =~ /^app/)
  #   follow_paths << "/data/main/current/log/#{node[:environment][:name]}.log"
  # end 
end

follow_paths.each do |path|
  execute "le follow #{path}" do
    command "le follow #{path}"
    ignore_failure true 
    action :run
  end
end

