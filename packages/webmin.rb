package :webmin do 
  requires :webmin_source_configured
  requires :webmin_pubkey_installed
  description "Webmin"
  runner "apt-get update"
  apt "webmin"
  verify { has_apt "webmin" }
end

package :webmin_source_configured do
  source = "deb http://download.webmin.com/download/repository sarge contrib"
  # TODO: make this append a helper method
  runner "sh -c \'echo #{source} | tee -a /etc/apt/sources.list\'"
  verify { file_contains "/etc/apt/sources.list", source }
end

package :webmin_pubkey_installed do
  runner "true; wget http://www.webmin.com/jcameron-key.asc"
  runner "apt-key add jcameron-key.asc"
  runner "apt-key list > apt-key-list"
  verify { file_contains "apt-key-list", "jcameron" }
end
