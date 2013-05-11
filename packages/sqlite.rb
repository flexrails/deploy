package :sqlite, :provides => :database do |variable|
	description 'SQLite3 Database'
	apt "sqlite3"
	verify { has_apt "sqlite3" }
end
