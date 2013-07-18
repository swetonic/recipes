#
# Cookbook Name:: sidekiq
# Recipe:: default
#
if ['solo', 'util'].include?(node[:instance_role])
  # Unmask ffmpeg
  enable_package "media-video/ffmpeg" do
    version "0.4.9_p20090201"
  end

  package "media-video/ffmpeg" do
    version "0.4.9_p20090201"
    action :install
  end
  
  
  execute "install sidekiq gem" do
    command "gem install sidekiq -r"
    not_if { "gem list | grep sidekiq" }
  end

  
    concurrency = 50
  

    node[:applications].each do |app, data|
      template "/etc/monit.d/sidekiq_#{app}.monitrc" do 
      owner 'root' 
      group 'root' 
      mode 0644 
      source "monitrc.conf.erb" 
      variables({ 
        :concurrency => concurrency,
        :app_name => app, 
        :rails_env => node[:environment][:framework_env] 
      }) 
    end

    execute "ensure-sidekiq-is-setup-with-monit" do 
      epic_fail true
      command %Q{ 
        monit reload 
      } 
    end
  end 
end
