load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

default_run_options[:pty] = true
set :application, "oots"
set :scm, "git"
set :repository, "git@github.com:slowernet/oots.git"
set :branch, "master"
set :deploy_to, "/home/eshepard/applications/oots"
set :keep_releases, 2
set :use_sudo, false
set :user, "eshepard"

set :domain, "207.192.74.39"
server domain, :app, :web
role :db, domain, :primary => true

namespace :deploy do
	
	task :tail_production, :roles => :app do
	  stream "tail -f #{current_path}/log/production.log"
	end
	
	desc "Creating tmp directory"
	task :create_tmpdir do
		# Make shared directories.
		%w(
			tmp/
		).each { |path| run "mkdir -p #{release_path}/#{path}" }	
	end

	desc "Symlinking shared directories"
	task :symlink_shared_directories do
		# symlink shared directories
		%w(
			public/assets
		).each do |path|
			run "rm -rf #{release_path}/#{path}"
			run "ln -sf #{shared_path}/#{path} #{release_path}/#{path}"
		end
	end
	
	desc "Creating shared directories"
	task :create_shared_directories do
		# Make shared directories.
		%w(
			config/
		).each {|path| run "mkdir -p #{shared_path}/#{path}" }	
	end
	
	desc "Restarting application"
	task :passenger_restart do
		run "touch #{release_path}/tmp/restart.txt"
	end
	
end

# after "deploy:setup", "deploy:create_shared_directories"
#after "deploy:update_code", "deploy:symlink_shared_directories"
after "deploy:update_code", "deploy:create_tmpdir"
after "deploy:update_code", "deploy:passenger_restart"
after "deploy:update", "deploy:cleanup"
