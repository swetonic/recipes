require 'pp'
#
# Cookbook Name:: memcached
# Recipe:: default
#

node[:applications].each do |app_name,data|
  user = node[:users].first

  #lets not use util servers(which we might be more open to removing in flight)
  
  if ["solo", "app", "app_master"].include?(node[:instance_role])
   template "/data/#{app_name}/shared/config/memcached_custom.yml" do
     source "memcached.yml.erb"
     owner user[:username]
     group user[:username]
     mode 0744
     variables({
         :app_name => app_name,
         :server_names => node[:members]
     })
   end

   #we use large instances with lots of memory
   #if we ever switch to lower memory app servers
   #this will need to be revisited		
   template "/etc/conf.d/memcached" do
     owner 'root'
     group 'root'
     mode 0644
     source "memcached.erb"
     variables :memusage => 1024,
               :port     => 11211
   end
  end
end
