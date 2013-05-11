package :apache, :provides => :webserver do
	description "apache2"
	apt "apache2"
	verify do 
		has_apt "apache2"
		has_process "apache2"
	end
end
