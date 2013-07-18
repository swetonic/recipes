#
# Cookbook Name:: sidekiq
# Recipe:: default
#

require_recipe "sidekiq_ecx::configure"
require_recipe "sidekiq_ecx::restart"
