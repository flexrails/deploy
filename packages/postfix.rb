package :postfix, :provides => :mailer do
  description "Postfix"  
  apt "postfix"
  verify { has_apt "postfix" }
end