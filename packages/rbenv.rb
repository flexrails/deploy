package :rbenv do
	requires :rbenvrc_added_to_bash
	requires :rbenvrc_added_to_profile
end

package :rbenv_installed do
	requires :git
	runner "true; git clone git://github.com/sstephenson/rbenv.git .rbenv"
	verify { has_executable ".rbenv/bin/rbenv" }
end

package :rbenvrc_created do
	requires :rbenv_installed
	rbenvrc = <<-EOS
		export PATH=$HOME/.rbenv/bin:$PATH
		eval "$(rbenv init -)"
	EOS
	push_text rbenvrc, "$HOME/.rbenvrc"
	verify do
		has_file "$HOME/.rbenvrc"
		file_contains ".rbenvrc", "rbenv init"
	end
end

package :rbenvrc_added_to_bash do
	requires :rbenvrc_created
	# TODO: use push_text instead
	runner "true; echo 'source $HOME/.rbenvrc'|cat - $HOME/.bashrc|tee $HOME/.bashrc > /dev/null"
	verify { file_contains "$HOME/.bashrc", ".rbenvrc" }
end

package :rbenvrc_added_to_profile do
	requires :rbenvrc_created
	runner "true; echo 'source $HOME/.rbenvrc'|cat - $HOME/.profile|tee $HOME/.profile > /dev/null"
	verify { file contains "$HOME/.profile", ".rbenvrc" }
end