require_recipe "memcached"
# we use emerge to get latest version of libxml2
require_recipe "emerge"
require_recipe "elasticsearch"
require_recipe "elasticsearch-yml"
require_recipe "database"
require_recipe "sidekiq_ecx"
require_recipe "redis"
require_recipe "redis-yml"
#require_recipe "ecx-ymls"
#require_recipe "cron_check" #EY has their own version of this
#just run whenever on app restart no chef required
require_recipe "scout_agent"
require_recipe "jasper_reports_server"
require_recipe "scheduled_tasks"
require_recipe "le"
require_recipe "s3cmd"

