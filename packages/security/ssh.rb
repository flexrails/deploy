package :sshd_config do
  requires :sshd_config_no_root_login
  requires :sshd_config_no_password_authentication
  # TODO: restart
end

package :sshd_config_no_root_login do 
  requires :sshd_config_backup
  pattern = "PermitRootLogin (yes|no)"
  value = "PermitRootLogin no"
  configure_option(pattern, value, "/etc/ssh/sshd_config")
end

package :sshd_config_no_password_authentication do
  requires :sshd_config_backup
  pattern = "PasswordAuthentication (yes|no)"  
  value = "PasswordAuthentication no"
  configure_option(pattern, value, "/etc/ssh/sshd_config")
end

package :sshd_config_backup do
  runner "cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig"
  verify { has_file "/etc/ssh/sshd_config.orig" }
end
