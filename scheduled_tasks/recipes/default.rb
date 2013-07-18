if sidekiq_instance?

  cron 'clear_reset_purchased_cache' do
    minute  '10'
    weekday '4'
    hour    '21'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''Diamond.reset_recently_purchased_cache'\'' >> cron_error.log 2>&1'"
  end

  # once an hour during business hours
  cron 'post_order_export' do
    minute  '0'
    hour    '10,11,12,13,14,15,16,17,18,19,20,21,22'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''EcxUtils.post_order_export'\'' >> cron_error.log 2>&1'"
  end
  
  cron 'post_allorder_export' do
    minute  '0'
    hour    '1,13,19'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''EcxUtils.post_allorder_export'\'' >> cron_error.log 2>&1'"
  end

  # Once an hour jobs

  cron 'transfer_catalog_to_fiftyone' do
    minute  '5'
    hour    '2,8,14,20'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''FiftyOne::Trigger.transfer_catalog'\'' >> cron_error.log 2>&1'"
  end

  cron 'reminder_see_in_person' do
    minute  '10'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && RAILS_ENV=production bundle exec rake mailer_jobs:reminder_for_see_in_person_items --silent'"
  end

  
  cron 'video_importer' do
    minute  '20'
    hour    '2,6,10,14,18,22'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''DiamondVideoImporterWorker.perform_async'\'' >> cron_error.log 2>&1'"
  end
  
  # Twice a day jobs
  cron 'ogi_certs_refresh' do
    minute  '25'
    hour    '8,20'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''GetNewOgiCertificatesWorker.perform_async'\'' >> cron_error.log 2>&1'"
  end

  cron 'check_for_deliveries' do
    minute  '50'
    hour    '8,20'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''Spree::Order.check_for_deliveries'\'' >> cron_error.log 2>&1'"
  end

  cron 'import_power_reviews' do
    minute  '15'
    hour    '1,13'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && RAILS_ENV=production bundle exec rake ecx:import_powerreviews_review_data --silent'"
  end

  cron 'retry_hung_videos' do
    minute  '15'
    hour    '2,14'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''Video.retry_hung_jobs'\'' >> cron_error.log 2>&1'"
  end

  cron 'retry_failed_videos' do
    minute  '30'
    hour    '2,14'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''Video.retry_failed_jobs'\'' >> cron_error.log 2>&1'"
  end

  cron 'clean_all_the_temp_things' do
    minute  '45'
    hour    '2,14'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''TempCleaner.new.clean_all_the_temp_things'\'' >> cron_error.log 2>&1'"
  end
  
  # Once a day cron jobs
  cron 'export_power_reviews_product_feed' do
    minute  '15'
    hour    '3'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && RAILS_ENV=production bundle exec rake ecx:export_powerreviews_product_feed --silent'"
  end

  cron 'export_catalog_lithyem' do
    minute  '0'
    hour    '9'
    weekday '4'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && RAILS_ENV=production bundle exec rake ecx:export_catalog_lithyem --silent'"
  end

  cron 'email_daily_review_invitations' do
    minute  '35'
    hour    '3'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && RAILS_ENV=production bundle exec rake ecx:email_daily_review_invitations --silent'"
  end

  cron 'email_daily_review_reminder_invitations' do
    minute  '35'
    hour    '15'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && RAILS_ENV=production bundle exec rake ecx:email_reminder_review_invitations --silent'"
  end

  cron 'send_daily_vg_promo_emails' do
    minute  '45'
    hour    '15'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && RAILS_ENV=production bundle exec rake ecx:send_vg_promo_email_daily --silent'"
  end

  cron 'send_daily_ring_promo_emails' do
    minute  '15'
    hour    '15'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && RAILS_ENV=production bundle exec rake ecx:send_wedding_ring_promo_email --silent'"
  end

  cron 'export_google_product_feed' do
    minute  '45'
    hour    '3'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && RAILS_ENV=production bundle exec rake ecx:export_google_product_feed --silent'"
  end

  cron 'pentaho' do
    minute  '5'
    hour    '3,10,17'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''EcxUtils.execute_pentaho'\'' >> cron_error.log 2>&1'"
  end

  cron 'export_diamonds' do
    minute  '50'
    hour    '4'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''DiamondExporter.new.export_diamonds'\'' >> cron_error.log 2>&1'"
  end
  
  # refresh_diamonds needs to have pentaho run first
  cron 'refresh_diamonds' do
    minute  '35'
    hour    '3,10,17'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''DiamondFeedWorker.refresh_diamonds'\'' >> cron_error.log 2>&1'"
  end
  
  cron 'failed_consultation_orders' do
    minute  '55'
    hour    '7'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''Spree::Order.move_failed_consultation_orders_to_return'\'' >> cron_error.log 2>&1'"
  end

  cron 'download_fifty_one_orders' do
    minute  '45'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && script/rails runner -e production '\''FiftyOne::Order.download_purchase_orders'\'' >> cron_error.log 2>&1'"
  end

  cron 'srk download' do
    minute  '5'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/data-integration && ./kitchen.sh -log=/home/deploy/srkdownload.log -file=srkdown.kjb -param:dbhost=''ec2-50-112-82-235.us-west-2.compute.amazonaws.com'' -param:dbname=''main'' -param:dbuser=''deploy'' -param:dbpass=''CMygwZ7c8j'' >> cron_error.log 2>&1'  "
  end

  # Once a week jobs
  cron 'export_qualifying_referrals_list' do
    minute  '15'
    hour    '1'
    weekday '0'
    user    node[:owner_name]
    command "/bin/bash -l -c 'cd /data/main/current && RAILS_ENV=production bundle exec rake ecx:send_referral_list[bethv@ritani.com] --silent'"
  end
end
