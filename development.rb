require "./packages.rb"

deployment do
  delivery :capistrano do
	    set :user, DEPLOY_USER
	    role :dev, "127.0.0.1"
	    set :use_sudo, false
	    default_run_options[:pty] = true
  	end
end

policy :target, :roles => :dev do
  requires :app_packages
  requires :subversion
  requires :mysql
  requires :rails3
#  requires :rails3
#  requires :mysql
#  requires :sqlite
#  requires :security
#  requires :webmin
end

package :application do
#	requires :rails3, :app_packages, :subversion
end

package :security do
#  requires :sshd_config
#  requires :firewall
#  requires :logcheck
#  requires :logwatch
#  requires :nmap
end

apt_packages :app_packages, %w( imagemagick redis-server libxslt1-dev libxml2-dev mysql-client libmysql-ruby mysql-server libmysqlclient-dev )
