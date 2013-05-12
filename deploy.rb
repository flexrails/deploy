DEPLOY_USER=ENV["DEPLOY_USER"] || ENV["USER"]
DEPLOY_PASSWD=ENV["DEPLOY_PASSWD"] || "test"

puts "DEPLOY FOR #{DEPLOY_USER}"
set :user, DEPLOY_USER

role :dev,	"127.0.0.1"
role :web, 	"to.be.defined"
role :app, 	"to.be.defined"
role :db, 	"to.be.defined"

set :use_sudo, true

default_run_options[:pty] = true

ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_dsa")]
