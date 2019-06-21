#!/usr/bin/env ruby

require 'net/ssh'

command = 'systemctl suspend'

Net::SSH.start(ENV['SSH_ENDPOINT'], ENV['SSH_USERNAME'], :password => ENV['SSH_PASSWORD']) do |ssh|
  # capture all stderr and stdout output from a remote process
  output = ssh.exec!("hostname")
  puts output
  
  ssh.exec "systemctl suspend"
end
