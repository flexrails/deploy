package :sshd_config do
  requires :sshd_config_backup
  #requires :key_generation_or_key_propagation

  configure_option("PermitRootLogin (yes|no)", "PermitRootLogin no", "/etc/ssh/sshd_config")
  configure_option("PasswordAuthentication (yes|no)", "PasswordAuthentication no", "/etc/ssh/sshd_config")
  runner "service ssh reload"
end

package :sshd_config_backup do
  runner "cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig"
  verify { has_file "/etc/ssh/sshd_config.orig" }
end

