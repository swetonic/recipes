if ["solo", "app", "app_master", "util"].include?(node[:instance_role])
  node[:applications].each do |app, data|
    template "/data/#{app}/shared/config/newrelic.yml"do
      source 'newrelic.yml.erb'
      owner node[:owner_name]
      group node[:owner_name]
      mode 0600
      backup 0
      variables({
        :environment => node[:environment][:framework_env],
        :app_name => node[:environment_name],
        :license => 'ee5d3c06856244b0be8fa0d7d3bc9ba64fe620b0'
      })
    end
    
    
    template "/data/#{app}/shared/config/carrierwave.yml" do
      source 'carrierwave.yml.erb'
      owner node[:owner_name]
      group node[:owner_name]
      mode 0600
      backup 0
      variables({
        :environment => node[:environment][:framework_env],
        :fog_directory => "newecx-#{node[:clustername].downcase.strip}"
      })
    end
    
    template "/data/#{app}/shared/config/asset_hosts.yml" do
      source 'asset_hosts.yml.erb'
      owner node[:owner_name]
      group node[:owner_name]
      mode 0600
      backup 0
      variables({
        :environment => node[:environment][:framework_env],
        :asset_host => 'd2fg1oqsiyt2px.cloudfront.net'
      })
    end
  end
end