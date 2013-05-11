# local> sprinkle -c -v -s install.rb

require "packages.rb"

deployment do
	delivery :capistrano
end

policy :target, :roles => :app do
	requires :rails3
	requires :appserver
end

policy :target, :roles => :web do
	requires :webserver
end

policy :target, :roles => :db do
	requires :database
end

package :application do
	requires :rails2, :app_packages, :subversion
end

apt_packages :tsh_packages, %w( curl libxslt-dev libxml2-dev mysql-client libmysql-ruby mysql-server libmysqlclient-dev )

#apt_packages :capybara, %w( libqt4-dev )
#install phantomjs
