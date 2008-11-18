require 'rubygems'
require 'sinatra'
require 'sequel'

DB = Sequel.sqlite('irc.db')

get '/' do
  @channels = DB.fetch("SELECT distinct channel FROM messages")
  haml :index
end

get '/:channel' do
  channel = "##{params[:channel]}"
  @messages = DB[:messages].where(:channel => channel).order(:at)
  haml :log
end

get '/:channel/:date' do
  channel = "##{params[:channel]}"
  @messages = DB[:messages].where(:channel => channel).filter('DATE(at) = ?', Time.now.to_date).order(:at)
  haml :log
end

use_in_file_templates!

__END__

@@ layout
%html
  %body
    = yield

@@ index
%ul
  - @channels.each do |channel|
    %li
      %a{:href => "/#{channel[:channel][1..-1]}"}= channel[:channel]

@@ log
%table
  - @messages.each do |message|
    %tr
      %td= message[:at].strftime('%H:%M')
      %td
        %strong= message[:nick]
      %td= message[:message]
