require 'bundler/capistrano'

set :default_environment, {
  'PATH' => "/home/ubuntu/.rvm/gems/ruby-1.9.2-p180/bin:/home/ubuntu/.rvm/gems/ruby-1.9.2-p180@global/bin:/home/ubuntu/.rvm/rubies/ruby-1.9.2-p180/bin:/home/ubuntu/.rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
  'RUBY_VERSION' => 'ruby 1.9.2',
  'GEM_HOME'     => '/home/ubuntu/.rvm/gems/ruby-1.9.2-p180',
  'GEM_PATH'     => '/home/ubuntu/.rvm/gems/ruby-1.9.2-p180:/home/ubuntu/.rvm/gems/ruby-1.9.2-p180@global',
  'BUNDLE_PATH'  => '/home/ubuntu/.rvm/gems/ruby-1.9.2-p180'  # If you are using bundler.
}

set :application, "elektrojan"
set :repository,  "."

set :deploy_to, "/var/www/#{application}"
set :deploy_via, :copy
set :copy_cache, :true
set :copy_exclude, ['.git']

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
server '50.17.223.232', :web, :app, :db, :primary => true

set :user, 'ubuntu'
set :try_sudo, true

default_run_options[:pty] = true

ssh_options[:keys] = [File.join(ENV["HOME"], "aws", "default.pem")]
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

namespace :files do
  task :upload_missing do
    upload("config/initializers/secret_token.rb", "#{current_path}/config/initializers/secret_token.rb")
    upload("config/environments/production.rb",   "#{current_path}/config/environments/production.rb")
  end
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :precompile_assets, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path}; rm -rf public/assets/*"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake assets:precompile"
end

namespace :uploads do

  desc <<-EOD
    Creates the upload folders unless they exist
    and sets the proper upload permissions.
  EOD
  task :setup, :except => { :no_release => true } do
    dirs = uploads_dirs.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
  end

  desc <<-EOD
    [internal] Creates the symlink to uploads shared folder
    for the most recently deployed version.
  EOD
  task :symlink, :except => { :no_release => true } do
    run "rm -rf #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end

  desc <<-EOD
    [internal] Computes uploads directory paths
    and registers them in Capistrano environment.
  EOD
  task :register_dirs do
    set :uploads_dirs,    %w(uploads)
    set :shared_children, fetch(:shared_children) + fetch(:uploads_dirs)
  end

  after       "deploy:finalize_update", "uploads:symlink"
  on :start,  "uploads:register_dirs"

end

after "deploy", "precompile_assets"
after "deploy", "files:upload_missing"
after "deploy", "deploy:migrate"
after "deploy", "deploy:restart"
