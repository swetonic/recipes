#
# Cookbook Name:: logentries
# Recipe:: default
#
require_recipe 'le::install'
require_recipe 'le::configure'
require_recipe 'le::restart'
