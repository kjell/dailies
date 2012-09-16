#!/usr/bin/env ruby
%w(rubygems fileutils simple-daemon).each {|lib| require lib}

BASE = '/Users/Shared/dailies'

class Dailies < SimpleDaemon::Base
  SimpleDaemon::WORKING_DIRECTORY = BASE

  def self.snap
    dir, file = File.join(BASE, Time.now.strftime('%Y/%m/%d-%H%M')).split('-')
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    #File.open("#{dir}/#{file}.log", 'w') do |f|
    #  f <<
    #end
    system("/usr/local/bin/imagesnap #{dir}/#{file}.jpg")
  end

  def self.start
    loop do
      snap; sleep 1987
    end
  end

  def self.stop
  end
end

ARGV[0] ? Dailies.daemonize : Dailies.snap
