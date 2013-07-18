if sidekiq_instance?
  # TODO - we should be able to remove the sandboxed email and db queus and use a sufficiently high weighting(say a million). This will allow us
  # to max out all 7 sidekiq processes. Assuming that the change in weighting(blocker=>10000) works as expected - please make that change
  # and remove this notes.
  worker_count = 7

  node[:applications].each do |app, data|
    template "/etc/monit.d/sidekiq_main.monitrc" do
      owner 'root'
      group 'root'
      mode 0644
      backup 0
      source "monitrc.conf.erb"
      variables({
                    :num_workers => worker_count,
                    :app_name => app,
                    :rails_env => node[:environment][:framework_env]
                })
    end

    template "/engineyard/bin/sidekiq" do
      owner 'root'
      group 'root'
      mode 0755
      backup 0
      source "sidekiq.erb"
      variables({
                    :concurrency => 2,
                    :backtrace => true,
                    :queues => {
                        :blocker => 100000,
                        :db => 1000,
                        :default => 1000,
                        :critical => 1000,
                        :minor => 100,
                        :trivial => 10,
                    }
                })
    end

    #we probably shouldn't do this - but being extra careful
    template "/engineyard/bin/sidekiq_blocker" do
      owner 'root'
      group 'root'
      mode 0755
      backup 0
      source "sidekiq.erb"
      variables({
                    :concurrency => 2,
                    :backtrace => true,
                    :queues => {
                        :blocker => 1
                    }
                })
    end


    template "/engineyard/bin/sidekiq_bottleneck0" do
      owner 'root'
      group 'root'
      mode 0755
      backup 0
      source "sidekiq.erb"
      variables({
                    :concurrency => 2,
                    :backtrace => true,
                    :queues => {
                        :blocker => 10000,
                        :db => 1000,
                        :default => 1000,
                        :critical => 1000,
                        :minor => 100,
                        :trivial => 10,
                        :bottleneck => 1,
                    }
                })
    end
    template "/engineyard/bin/sidekiq_bottleneck1" do
      owner 'root'
      group 'root'
      mode 0755
      backup 0
      source "sidekiq.erb"
      variables({
                    :concurrency => 2,
                    :backtrace => true,
                    :queues => {
                        :blocker => 10000,
                        :db => 1000,
                        :default => 1000,
                        :critical => 1000,
                        :minor => 100,
                        :trivial => 10,
                        :bottleneck => 1,
                    }
                })
    end
    template "/engineyard/bin/sidekiq_bottleneck2" do
      owner 'root'
      group 'root'
      mode 0755
      backup 0
      source "sidekiq.erb"
      variables({
                    :concurrency => 2,
                    :backtrace => true,
                    :queues => {
                        :blocker => 10000,
                        :db => 1000,
                        :default => 1000,
                        :critical => 1000,
                        :minor => 100,
                        :trivial => 10,
                        :bottleneck => 1,
                    }
                })
    end


    template "/engineyard/bin/sidekiq_email" do
      owner 'root'
      group 'root'
      mode 0755
      backup 0
      source "sidekiq.erb"
      variables({
                    :concurrency => 50,
                    :backtrace => true,
                    :queues => {
                        :default => 1
                    }
                })
    end

    [0, 1, 'blocker', 'bottleneck0', 'bottleneck1', 'bottleneck2', 'email'].each do |count|
      template "/data/#{app}/shared/config/sidekiq_#{count}.yml" do
        owner node[:owner_name]
        group node[:owner_name]
        mode 0644
        backup 0
        source "sidekiq.yml.erb"
        variables({
                      :require => "/data/main/current",
                      :environment => node[:environment][:framework_env]
                  })
      end
    end
  end
end
