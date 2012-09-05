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


download_file = File.join('/usr/src', node['splunk']['server']['package'])


remote_file 'Splunk Server: Download Package' do
  action :nothing
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


package 'Splunk Server: Install Package' do
  provider Chef::Provider::Package::Dpkg
  subscribes(
    :install,
    resources(:remote_file => 'Splunk Server: Download Package'),
    :immediately
  )
  package_name node['splunk']['server']['package']
  source download_file
end


execute 'Splunk Server: Enable Boot-Start' do
  creates '/etc/init.d/splunk'
	command '/opt/splunk/bin/splunk enable boot-start --answer-yes'
end


service 'splunk' do
  action :start
end
