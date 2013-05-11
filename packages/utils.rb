def runner2(cmds)
	runner cmds
end

def has_apt(pkg)
	has_version_in_grep "dpkg -l", " #{pkg} "
end

def apt_packages(target, pkgs)
	pkgs.to_a.each do |pkg|
		package pkg do
			apt pkg
			verify { has_apt pkg }
		end
	end

	package target do
		pkgs.to_a.each do |pkg|
			requires pkg
		end
		verify {  }
	end
end

def ask_with_default(var, default)
	set(var) do
		Capistrano::CLI.ui.ask "#{var}? [#{default}] : "		
	end

	set var, default if eval("#{var.to_s}.empty?")
end