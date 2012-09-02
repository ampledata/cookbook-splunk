#
# Cookbook Name:: splunk
# Recipe:: server
#
# Author:: Greg Albrecht (<mailto:gba@splunk.com>)
# Copyright 2012 Splunk, Inc.
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


download_file = File.join(Dir.mktmpdir, node['splunk']['server']['package'])


execute 'Splunk Server: Enable Boot-Start' do
  action :nothing
	command '/opt/splunk/bin/splunk enable boot-start --answer-yes'
end


package 'Splunk Server: Install Package' do
  package_name node['splunk']['server']['package']
  action :nothing
  notifies :run, resources(:execute => 'Splunk Server: Enable Boot-Start')
  source download_file
end


remote_file 'Splunk Server: Download Package' do
  action :nothing
  notifies(
    :install,
    resources(:package => 'Splunk Server: Install Package'),
    :immediately
  )
  path download_file
  source node['splunk']['server']['download_url']
end


http_request ['HEAD', node['splunk']['server']['download_url']].join(' ') do
  action :head
  notifies(
    :create,
    resources(:remote_file => 'Splunk Server: Download Package'),
    :immediately
  )

  message String.new
  url node['splunk']['server']['download_url']

  if File.exists?(download_file)
    headers 'If-Modified-Since' => File.mtime(download_file).httpdate
  end
end
