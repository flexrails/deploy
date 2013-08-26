package :rails3, :provides => :rails do
	version "3.2.8"
	requires :ruby193
	requires :rails_dependencies
	requires :bundler

	gemfile = <<-EOS
		source "http://rubygems.org"
		gem 'rails', '3.2.8'
		gem 'therubyracer'
	EOS
	push_text gemfile, "Gemfile"

	runner "true; bundle install"
	runner "true; rbenv rehash"
	runner "true; rails new testapp"
	push_text 'gem "therubyracer"', "testapp/Gemfile"

	verify { file_contains "testapp/Gemfile", 'gem "therubyracer"' }
end

package :rails2, :provides => :rails do
	version "2.3.11"
	requires :ruby187
	requires :rails_dependencies
	requires :bundler

	gemfile = <<-EOS
		source "http://rubygems.org"
		gem 'rails', '2.3.11'
	EOS
	push_text gemfile, "Gemfile"

	runner "true; bundle install"
	runner "true; rbenv rehash"
	runner "true; rails testapp"
end

apt_packages :rails_dependencies, %w( libsqlite3-dev )

