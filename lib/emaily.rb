require 'rubygems'
require 'mail'
require 'yaml'
require 'socket'
require 'openssl'

require 'emaily/csv'
require 'emaily/servers'
require 'emaily/webservers'
require 'emaily/templates'
require 'emaily/emaily'


### USE CASES

# > emaily -email templates/facebook.html -subject "Facebook Invitation" -list emails.csv
