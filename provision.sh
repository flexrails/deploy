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

usage() {
cat <<EOF
Usage: $0 <deploy user> <deploy server>

OPTIONS:
  -h              Show this message
  -s <username>   Sudo username
  -p <port>       SSH port
  -i <filename>   Public key

EOF
exit
}

SUDO_USER=root
SSH_PORT_OPTIONS=
DEPLOY_PUBKEY=~/.ssh/id_dsa.pub

options='hs:p:i:'
while getopts $options option
do
  case $option in 
    h)  usage;;
    s)  SUDO_USER=$OPTARG;;
    p)  SSH_PORT_OPTIONS="-p $OPTARG";;
    i)  DEPLOY_PUBKEY=$OPTARG;;
  esac
done

shift $(($OPTIND-1))      # $1 is now the first non-option argument

[ "$#" -eq 2 ] || usage

DEPLOY_USER=$1
DEPLOY_SERVER=$2

# exit on error
set -e 

read -s -p "Choose a password for ${DEPLOY_USER}@${DEPLOY_SERVER}: " PASSWORD
PASSWORD_HASH=$(perl -e 'print crypt($ARGV[0], "password")' ${PASSWORD})

echo
echo Provisioning server ${DEPLOY_SERVER}

echo Copying public key to ${SUDO_USER}@${DEPLOY_SERVER}, please provide password for ${SUDO_USER}@${DEPLOY_SERVER}
ssh-copy-id -i ${DEPLOY_PUBKEY} "${SUDO_USER}@${DEPLOY_SERVER} ${SSH_PORT_OPTIONS}"

echo Installing ruby, git, sprinkle on ${DEPLOY_SERVER}
ssh ${SSH_PORT_OPTIONS} ${SUDO_USER}@${DEPLOY_SERVER} "sudo apt-get -y update; sudo apt-get -y install rubygems git; sudo gem install sprinkle --no-rdoc --no-ri"

echo Creating user ${DEPLOY_USER}@${DEPLOY_SERVER}
ssh ${SSH_PORT_OPTIONS} ${SUDO_USER}@${DEPLOY_SERVER} "sudo useradd -m -G sudo -s /bin/bash -p ${PASSWORD_HASH} ${DEPLOY_USER}"

echo Copying public key to ${DEPLOY_USER}@${DEPLOY_SERVER}, please provide password for ${DEPLOY_USER}@${DEPLOY_SERVER}
ssh-copy-id -i ${DEPLOY_PUBKEY} "${DEPLOY_USER}@${DEPLOY_SERVER} ${SSH_PORT_OPTIONS}"

echo Cloning and running deploy scripts on ${DEPLOY_USER}@${DEPLOY_SERVER}
ssh ${SSH_PORT_OPTIONS} ${DEPLOY_USER}@${DEPLOY_SERVER} "git clone https://github.com/flexrails/deploy"

echo Provisioning finished. You can now login to ${DEPLOY_USER}@${DEPLOY_SERVER} and continue using
echo "cd deploy; sprinkle -c -v -s development.rb"

# TODO: why need password again?
# TODO: gen key on deployed server?
# TOOD: don't select ruby/rails version
# TODO: remove public key from root
# TODO: disable root remote login
