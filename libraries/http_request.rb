#!/usr/bin/env ruby
# Work-around for STORM-4388 aka CHEF-3218
#
# Overloading the default Chef::REST instantiation w/ disable_gzip set to true.
#
# See Also:
# http://jira.splunk.com:8080/browse/STORM-4388
# http://tickets.opscode.com/browse/CHEF-3218
#
# Author:: Greg Albrecht <mailto:gba@splunk.com>
# Library:: http_request
# Cookbook Name:: splunk
# Copyright:: Copyright 2012 Splunk, Inc.
# License:: Apache License 2.0
#


class Chef
  class Provider
    class HttpRequest < Chef::Provider
      def load_current_resource
        @rest = Chef::REST.new(@new_resource.url, nil, nil, options={:disable_gzip => true})
        Chef::Log.warn('STORM-4388 CHEF-3218 Work-around.')
      end
    end
  end
end
