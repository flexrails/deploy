require "packages.rb"

deployment do
	delivery :capistrano do
	    set :user, DEPLOY_USER
	    role :dev, "127.0.0.1"
	    set :use_sudo, false
	    default_run_options[:pty] = true
  	end
end

policy :target, :roles => :dev do
  requires :redmine
end
