package :git do
	description "GIT"
	requires :apt_update
	apt "git"
	verify { has_executable "/usr/bin/git" }
end
