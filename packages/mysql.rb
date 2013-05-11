package :mysql, :provides => :database do |variable|
	description 'MySQL Database'
	apt %w( mysql-server mysql-client )	
end
