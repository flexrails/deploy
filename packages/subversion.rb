package :subversion do
	description "Subversion"
	requires :apt_update
	apt "subversion"
	verify { has_apt "subversion" }	
end
