#!/usr/bin/env ruby
gem 'net-ssh', '= 5.2.0'
require 'net/ssh'

command = ''
if ARGV[0] == 'sleep' then
    command = 'sudo pm-suspend'
elsif ARGV[0] == 'hibernate' then
    command = 'sudo pm-hibernate'  
else
    command = 'systemctl suspend'
end

if ENV['USE_SSH_KEY'] == '0' then
    Net::SSH.start(ENV['SSH_ENDPOINT'], ENV['SSH_USERNAME'], :password => ENV['SSH_PASSWORD']) do |ssh|
        result = ssh.exec!(command)
        puts result
    end
else
    Net::SSH.start(ENV['SSH_ENDPOINT'], ENV['SSH_USERNAME'], :passphrase => ENV['SSH_PASSPHRASE']) do |ssh|
        result = ssh.exec!(command)
        puts result
    end
end 
