package :nmap do
  apt "nmap"
  verify { has_apt "nmap" }
end

package :nmap_secure do
  # TODO: add logcheck, add cron
end