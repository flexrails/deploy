#!/bin/bash
#
# SETS UP A MACHINE FROM WHICH WE CAN SPRINKLE
# THEN SPRINKLE FROM THAT MACHINE TO DEPLOY OTHER SERVERS
#
# Start with a fresh Debian/Ubuntu System (3GB Disk, 512MB Swap)
#
# REMOVE LOCAL KNOWN HOSTS
# rm ~/.ssh/known_hosts
#
# FIRST ADD AND UNLOCK THE SSH KEY INSIDE BASH
# ssh-agent $SHELL
# ssh-add
#
# http://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id/
# http://www.cyberciti.biz/tips/howto-write-shell-script-to-add-user.html
# 

die() {
  echo >&2 "$@"
  exit 1
}

# exit on error
set -e 

[ "$#" -eq 2 ] || die "Usage: provision <deploy user> <deploy server>"

DEPLOY_USER=$1
DEPLOY_SERVER=$2
DEPLOY_PUBKEY=~/.ssh/id_dsa.pub

read -s -p "Choose a password for ${DEPLOY_USER}@${DEPLOY_SERVER}: " PASSWORD
PASSWORD_HASH=$(perl -e 'print crypt($ARGV[0], "password")' ${PASSWORD})

echo
echo Provisioning server ${DEPLOY_SERVER}

echo Copying public key to root@${DEPLOY_SERVER}, please provide password for root@${DEPLOY_SERVER}
ssh-copy-id -i ${DEPLOY_PUBKEY} root@${DEPLOY_SERVER}

echo Installing ruby, git, sprinkle on ${DEPLOY_SERVER}
ssh root@${DEPLOY_SERVER} "apt-get -y update; apt-get -y install rubygems git; gem install sprinkle --no-rdoc --no-ri"

echo Creating user ${DEPLOY_USER}@${DEPLOY_SERVER}
ssh root@${DEPLOY_SERVER} "useradd -m -G sudo -s /bin/bash -p ${PASSWORD_HASH} ${DEPLOY_USER}"

echo Copying public key to ${DEPLOY_USER}@${DEPLOY_SERVER}, please provide password for ${DEPLOY_USER}@${DEPLOY_SERVER}
ssh-copy-id -i ${DEPLOY_PUBKEY} ${DEPLOY_USER}@${DEPLOY_SERVER}

echo Cloning and running deploy scripts on ${DEPLOY_USER}@${DEPLOY_SERVER}
ssh ${DEPLOY_USER}@${DEPLOY_SERVER} "git clone https://github.com/flexrails/deploy"

echo Provisioning finished. You can now login to ${DEPLOY_USER}@${DEPLOY_SERVER} and continue using
echo "cd deploy; sprinkle -c -v -s development.rb"

# TODO: why need password again?
# TODO: gen key on deployed server?
# TOOD: don't select ruby/rails version
# TODO: remove public key from root
# TODO: disable root remote login
