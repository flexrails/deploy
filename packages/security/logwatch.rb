package :logwatch do
  requires :mailer
  apt "logwatch"
  verify { has_apt "logwatch" }
end

#TODO: cron every 5 minutes, validate email delivery
