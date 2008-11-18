require 'rubygems'
require 'isaac'
require 'sequel'

DB = Sequel.sqlite('irc.db')

config do |c|
  c.nick = 'tracefunc'
  c.server = 'irc.freenode.net'
  c.port = 6667
end

on :connect do
  join '#merb', '#datamapper', '#rspec', '#cucumber'
end

on :channel, /.*/ do
  msg = message.chomp
  puts "#{channel} <#{nick}> #{msg}"
  DB[:messages] << {:channel => channel, :nick => nick, :message => msg, :at => Time.now}
end

trap("INT") do
  exit(0) # for some reason, ctrl+c won't quit normally
end
