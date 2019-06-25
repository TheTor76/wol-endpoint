#!/usr/bin/env ruby

require 'net/ssh'

Net::SSH.start(ENV['SSH_ENDPOINT'], ENV['SSH_USERNAME'], :password => ENV['SSH_PASSWORD']) do |ssh|
  # capture all stderr and stdout output from a remote process
  #output = ssh.exec!("hostname")
  #puts output
  
  if ARGV[0] == 'sleep' then	
    ssh.exec "sudo pm-suspend"
  elsif ARGV[0] == 'hibernate'
    output = ssh.exec!("sudo pm-hibernate")
  else
    output = ssh.exec!("systemctl suspend")
  end
  puts output
end
