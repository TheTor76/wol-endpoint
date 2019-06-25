#!/usr/bin/env ruby
gem 'net-ssh', '= 5.2.0'
require 'net/ssh'
#puts Net::SSH::Version::CURRENT

Net::SSH.start(ENV['SSH_ENDPOINT'], ENV['SSH_USERNAME'], :password => ENV['SSH_PASSWORD']) do |ssh|
    
  command = ''
  if ARGV[0] == 'sleep' then
    command = 'sudo pm-suspend'
  elsif ARGV[0] == 'hibernate' then
    command = 'sudo pm-hibernate'  
  else
    command = 'systemctl suspend'
  end
   
  # open a new channel and configure a minimal set of callbacks, then run
  # the event loop until the channel finishes (closes)
  channel = ssh.open_channel do |ch|
    $stdout.print "executing command: " + command
    ch.exec command do |ch, success|
      raise "could not execute command" unless success
      
      # "on_data" is called when the process writes something to stdout
      ch.on_data do |c, data|
        $stdout.print data
      end

      # "on_extended_data" is called when the process writes something to stderr
      ch.on_extended_data do |c, type, data|
        $stderr.print data
      end

      #ch.on_close { puts "done!" }
    end
  end
end



