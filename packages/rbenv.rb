package :rbenv do
	requires :git

	runner "true; git clone git://github.com/sstephenson/rbenv.git .rbenv"

	rbenvrc = <<-EOS
		export PATH=$HOME/.rbenv/bin:$PATH
		eval "$(rbenv init -)"
	EOS
	push_text rbenvrc, ".rbenvrc"

	runner "true; echo 'source $HOME/.rbenvrc'|cat - $HOME/.bashrc|tee $HOME/.bashrc > /dev/null"
	verify { has_executable ".rbenv/bin/rbenv" }
end

package :rbenv_bashrc do
	rbenvrc = <<-EOS
		export PATH=$HOME/.rbenv/bin:$PATH
		eval "$(rbenv init -)"
	EOS
	push_text rbenvrc, ".rbenvrc"
	verify { file_contains ".rbenvrc", "rbenv init" }
end

