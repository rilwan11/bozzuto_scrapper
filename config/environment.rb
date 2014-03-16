# => Define APP_ROOT constant
APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")).freeze unless defined?(APP_ROOT)
$LOAD_PATH << File.join(APP_ROOT, 'lib')

File.join(APP_ROOT, "log").tap do |log_dir|
  FileUtils.mkdir_p(log_dir) unless File.exists? log_dir

  # TODO: This configuration should be handled externally
  Logbert.root.handlers << Logbert::Handlers::StreamHandler.new($stdout)
  Logbert.root.handlers << Logbert::Handlers::StreamHandler.for_path(File.join(log_dir, "scrapper.log"))
  Logbert.root.level = :info
end

# => Define BOT_ENV constant
unless defined?(BOT_ENV)
  envs = ["development", "test", "staging", "production"]
  env  = ENV["ENV"].to_s.downcase
  env  = envs[0] unless envs.include?(env)
  BOT_ENV = env.freeze
end

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

require 'mechanize'
require './lib/allegro_scrapper'