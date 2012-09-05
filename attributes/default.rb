#
# Cookbook Name:: splunk
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


default['splunk']['server']['package'] = 'splunk-4.3.3-128297-linux-2.6-amd64.deb'
default['splunk']['server']['download_url'] = 'http://download.splunk.com/' +
  'releases/4.3.3/splunk/linux/splunk-4.3.3-128297-linux-2.6-amd64.deb'
