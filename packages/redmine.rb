package :redmine do
  requires :apache
  requires :mysql

  apt %w( redmine redmine-mysql libapache2-mod-passenger )
end
