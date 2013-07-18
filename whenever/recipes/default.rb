#
# Cookbook Name:: whenever
# Recipe:: default
#

ey_cloud_report "whenever" do
  message "starting whenever recipe"
end

if ['util'].include?(node[:instance_role])

  # be sure to replace "app_name" with the name of your application.
  local_user = node[:users].first
  node[:applications].each do |app, data|  
    execute "whenever" do
      cwd "/data/#{app}/current"
      user local_user[:username]
      command "/data/main/current/ey_bundler_binstubs/whenever --update-crontab '#{app}_#{node[:environment][:framework_env]}'"
      action :run
    end
  
    ey_cloud_report "whenever" do
      message "Whenever finished for #{app}"
    end
  end
end