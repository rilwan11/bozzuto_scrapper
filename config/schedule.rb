every 2.hours do
  command "cd #{path} && ENV=#{ENV['ENV']} /usr/local/bin/bundle exec rake scrapper:notify"
end