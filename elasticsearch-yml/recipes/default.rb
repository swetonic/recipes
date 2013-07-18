if ['app_master', 'app', 'util'].include?(node[:instance_role])
  elasticsearch_instance = node['utility_instances'].select {|instance| instance['name'] == 'elasticsearch_1'}.first
  
  node[:applications].each do |app, data|
    template "/data/#{app}/shared/config/elasticsearch.yml"do
      source 'elasticsearch.yml.erb'
      owner node[:owner_name]
      group node[:owner_name]
      mode 0600
      backup 0
      variables({
        :environment => node[:environment][:framework_env],
        :hosts => "#{elasticsearch_instance[:hostname]}:9200"
      })
    end
  end
end
