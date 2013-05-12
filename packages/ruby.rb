package :ruby193, :provides => :ruby do
	description "Ruby"
	version "1.9.3"
	requires :rbenv, :ruby_build, :ruby_dependencies

	v = "1.9.3-p194"
	runner "true; rbenv install #{v}"
	runner "true; rbenv local #{v}"
	runner "true; rbenv rehash"

	verify { has_version_in_grep bashify("rbenv versions"), v }
end

package :ruby187 do #, :provides => :ruby do
	description "Ruby"
	version "1.8.7"
	requires :rbenv, :ruby_build, :ruby_dependencies

	v="1.8.7-p358"
	runner "true; rbenv install #{v}"
	runner "true; rbenv local #{v}"
	runner "true; rbenv rehash"

	verify { has_version_in_grep bashify("rbenv versions"), v }
end

apt_packages :ruby_dependencies, %w( build-essential libssl-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev )

package :ruby_build do
	requires :git, :rbenv
	runner <<-EOS
		true; 
		mkdir -p ~/.rbenv/plugins;
		cd ~/.rbenv/plugins;
		git clone git://github.com/sstephenson/ruby-build.git;
		cd ruby-build;
		sudo ./install.sh
	EOS

	verify { has_executable "/usr/local/bin/ruby-build" }
end

package :bundler do
	requires :rbenv
	requires :ruby
	runner "true; gem install bundler"
	runner "true; rbenv rehash"
	verify { has_executable "bundle"}
end
