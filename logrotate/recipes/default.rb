#
# Cookbook Name:: logrotate
# Recipe:: default
#

remote_file "/etc/logrotate.d/nginx" do
  source "nginx.logrotate"
  owner "root"
  group "root"
  mode "0655"
  backup 0
end

cron "logrotate -f /etc/logrotate.d/nginx" do
  minute  '0'
  command "logrotate -f /etc/logrotate.d/nginx"
  user "root"
end


node[:applications].each do |app, data|
  template "/etc/logrotate.d/#{app}" do
    source "app.logrotate.erb"
    owner "root"
    group "root"
    mode "0655"
    variables({
      :app_name => app
    })
    backup 0
  end
  
  cron "logrotate -f /etc/logrotate.d/#{app}" do
    minute '0'
    command "logrotate -f /etc/logrotate.d/#{app}"
    user "root"
  end

end