require 'rubygems'
require 'mail'
require 'yaml'

require 'emaily/csv'
require 'emaily/servers'
require 'emaily/webserver'
require 'emaily/templates'
require 'emaily/emaily'


### USE CASES

# > emaily -email templates/facebook.html -subject "Facebook Invitation" -list emails.csv
