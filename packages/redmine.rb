package :redmine do
  requires :apache2
  requires :mysql

  apt %w( redmine redmine-mysql )
end