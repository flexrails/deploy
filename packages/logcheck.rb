package :logcheck do
  requires :mailer
  description "Logcheck"
  apt "logcheck"
  verify { has_apt "logcheck"}
end
