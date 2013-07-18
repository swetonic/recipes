#
# Cookbook Name:: scout_agent
# Recipe:: default
#
# Copyright 2011-2012, Michael A. Fiedler
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
node['scout_agent'] ||= {}
node['scout_agent']['user'] = "deploy"
node['scout_agent']['version'] = "5.5.8"
node['scout_agent']['rename'] = false

supported_environment = (node['environment']['framework_env'] == 'production')

if supported_environment
  node['scout_agent']['key'] = case node[:instance_role]
                                  when "util"
                                    if node[:name]['elasticsearch']
                                      'eeceeee8-da93-4368-b77c-d0774d18652f'
                                    elsif node[:name]['sidekiq']
                                      '4009faa1-da37-4cd8-ad53-5f38d1d16781'
                                    end
                                  when "db_master", "db_slave"
                                    '64c6b46d-7183-4028-8787-bf9f68a4206b'
                                  end
end

# install scout agent gem
execute "install scout gem" do
  command "gem install scout"
  not_if { "gem list | grep scout" }
end

execute "install dependencies for scout gem" do
  command "gem install mysql"
  not_if { "gem list | grep mysql" }
  command "gem install redis"
  not_if { "gem list | grep redis" }
end

if node['scout_agent']['key'] && supported_environment
  # we need to find where scout is installed
  # this may differ, depending on where chef is installed
  scout_bin = "scout"

  # Run scout with --name set to node name.
  # See: https://scoutapp.com/info/support#cloud_naming
  name_part = node['scout_agent']['rename'] ? "--name=\"#{node.name}\"" : ""
  scout_cmd = "#{scout_bin} #{name_part} #{node['scout_agent']['key']}"

  # schedule scout agent to run via cron
  cron "scout_run" do
    user node['scout_agent']['user']
    command "#{scout_cmd} # Managed by chef"
  end
else
  Chef::Log.info "Add a `node['scout_agent']['key']` attribute for Scout Agent."
end
