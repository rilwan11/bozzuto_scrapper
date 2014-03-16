set :application, "allegro_scrapper"
set :repository,  "https://github.com/Alexanderbez/bozzuto_scrapper.git"

set :scm, :git

set :use_sudo, false

set :whenever_environment, defer { stage }

ssh_options[:forward_agent] = true

# This capistrano hook lets capistrano write to crontab
require "whenever/capistrano"

namespace :deploy do

  desc "Update the crontab file"
  task :update_crontab do
    run "cd #{release_path} && ENV=#{environment} /usr/local/bin/bundle exec whenever --update-crontab #{application}"
    run "crontab -l"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.stop
    deploy.start
  end

  desc "Install Bundle"
  task :bundle_install, :roles => [:app, :worker] do
    run "mkdir -p #{shared_path}/bundle && cd #{release_path} && bundle install --deployment --without development test --path #{shared_path}/bundle"
  end
end

before 'deploy:create_symlink', 'deploy:bundle_install'

after "deploy:create_symlink", "deploy:update_crontab"