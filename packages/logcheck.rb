package :logcheck do
  description "Logcheck"
  apt "logcheck"
  verify { has_apt "logcheck"}
end
