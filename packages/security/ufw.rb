package :ufw, :provides => :firewall do  
  runner "sh -c 'echo y | ufw enable'"
  #verify { has_version_in_grep "/usr/sbin/ufw status", "Status: active" }  
  verify { has_version_in_grep "/usr/sbin/ufw", "args" }
end