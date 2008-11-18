#!/opt/local/bin/ruby
%w(rubygems fileutils simple-daemon).each {|lib| require lib}

BASE = '/Users/Shared/dailies'

class Dailies < SimpleDaemon::Base
  SimpleDaemon::WORKING_DIRECTORY = BASE

  def self.start
    loop do
      dir, file = File.join(BASE, Time.now.strftime('%Y/%m/%d')), Time.now.strftime('%H%M')
      FileUtils.mkdir_p(dir) unless File.directory?(dir)

      system("/Users/kjell/bin/camcapture #{dir}/#{file}")
      sleep 1987
    end
  end

  def self.stop; end
end

Dailies.daemonize
