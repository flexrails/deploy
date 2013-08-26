package :logwatch do
  requires :mailer
  apt "logwatch"
  verify { has_pt "logwatch" }
end

#TODO: cron every 5 minutes, validate email delivery
