#!/usr/bin/env rake

require "bundler/gem_tasks"

task :environment do
  load File.join(File.dirname(__FILE__), 'config', 'environment.rb')
end


namespace :scrapper do
	task :setup => :environment

	desc "Notify of available places to rent"
	task :notify => [:environment] do
		
	end

end