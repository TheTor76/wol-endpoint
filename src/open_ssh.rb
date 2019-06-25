#!/usr/bin/env ruby
gem 'net-ssh', '= 5.2.0'
require 'net/ssh'
#puts Net::SSH::Version::CURRENT

Net::SSH.start(ENV['SSH_ENDPOINT'], ENV['SSH_USERNAME'], :password => ENV['SSH_PASSWORD']) do |ssh|
  # capture all stderr and stdout output from a remote process
  #output = ssh.exec!("hostname")
  #puts output
  
  command = ''
  if ARGV[0] == 'sleep' then
    command = 'sudo pm-suspend'
  elsif ARGV[0] == 'hibernate' then
    command = 'sudo pm-hibernate'  
  else
    command = 'systemctl suspend'
  end

  
  #if ARGV[0] == 'sleep' then	
    #output = ssh.exec "sudo pm-suspend"
  #elsif ARGV[0] == 'hibernate'
  #  output = ssh.exec!("sudo pm-hibernate")
  #else
  #  output = ssh.exec!("systemctl suspend")
  #end
  #puts output
    
  # open a new channel and configure a minimal set of callbacks, then run
  # the event loop until the channel finishes (closes)
  channel = ssh.open_channel do |ch|
    ch.exec command do |ch, success|
      raise "could not execute command" unless success
      
      $stdout.print "executing command: " + command

      # "on_data" is called when the process writes something to stdout
      ch.on_data do |c, data|
        $stdout.print data
      end

      # "on_extended_data" is called when the process writes something to stderr
      ch.on_extended_data do |c, type, data|
        $stderr.print data
      end

      ch.on_close { puts "done!" }
    end
  end
end



