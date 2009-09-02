# RubyClicky A ruby library to access the GetClicky.com API
# Copyright (C) 2009 John Nagro
# Converted to ruby-clicky gem and modified by Andy Atkinson September 2009
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  
# Basically a straight port of GetClicky official PHP API function
# http://getclicky.com/clicky_log.phps
 
require 'uri'
require 'open-uri'
require 'yaml'

class GetClicky
 
  config = YAML::load_file("lib/config.yml")
  SITE_ID = config['SITE_ID']
  SITEKEY_ADMIN = config['SITEKEY_ADMIN']
  DATABASE_SERVER = config['DATABASE_SERVER']
 
  VALID_TYPES = ["pageview", "download", "outbound", "click", "custom", "goal"]
 
  def self.log(args)
 
    type = args[:type]
    type = "pageview" unless VALID_TYPES.include?(type)
 
    base_uri = "http://static.getclicky.com/in.php?site_id=#{SITE_ID}&srv=#{DATABASE_SERVER}&sitekey_admin=#{SITEKEY_ADMIN}&type=#{type}"
 
    # we need either a session_id or an ip_address...
    if(args[:session_id].is_a?(Numeric))
      base_uri += "&session_id=#{args[:session_id.to_i]}"
    elsif( (args[:ip_address] =~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/) != nil )
      base_uri += "&ip_address=#{args[:ip_address]}"
    else
      return false
    end
 
    # goals can come in as integer or array, for convenience
    if(args[:goal].is_a?(Numeric))
      base_uri += "&goal=#{args[:goal]}"
    elsif(args[:goal].is_a?(Hash) && args[:goal][:id].is_a?(Numeric))
      args[:goal].each do |key,value|
        base_uri += "&goal[#{URI.escape(key)}]=#{URI.escape(value)}"
      end
    end
 
    # custom data, must come in as array of key=>values
    if(args[:custom].is_a?(Hash))
      args[:custom].each do |key,value|
        base_uri += "&custom[#{URI.escape(key)}]=#{URI.escape(value)}"
      end
    end
 
    case args[:type]
    when "outbound"
      return false unless (args[:href] =~ /^(https?|telnet|ftp)/) != nil
    else
      # all other action types must start with either a / or a #
      args[:href] = "/#{args[:href]}" if((args[:href] =~ /^(\/|\#)/) == nil)
    end
 
    base_uri += "&href=#{URI.escape(args[:href])}"
 
    if(args[:title])
      base_uri += "&title=#{URI.escape(args[:tite])}"
    end
 
    if(args[:ref])
      base_uri += "&ref=#{URI.escape(args[:ref])}"
    end
 
    if(args[:ua])
      base_uri += "&ua=#{URI.escape(args[:ua])}"
    end
 
    return open(base_uri) ? true : false
  end
 
end