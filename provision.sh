#!/bin/bash
#
# sets up a fresh debian/ubuntu machine so that it can be used
# for deploying itself or other machines with sprinkle
#
# Start with a fresh Debian/Ubuntu System (3GB Disk, 512MB Swap)
#
# 1. install/start bash (windows/linux)
# 2. remove deploy server from ~/.ssh/known_hosts (optional)
# 3. bash> ssh-agent $SHELL
# 4. bash> ssh-add
# 5. bash> ./provision.sh -s vagrant -p 2222 deploy localhost
#
# http://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id/
# http://www.cyberciti.biz/tips/howto-write-shell-script-to-add-user.html 
# http://ryanbigg.com/2010/12/ubuntu-ruby-rvm-rails-and-you/
# https://github.com/joshfng/railsready
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

info() {
  echo -e "\e[1;37m$1\e[00m"
}

warn() {
  echo -e "\e[1;33m$1\e[00m"
}

error() {
  echo -e "\e[1;31m$1\e[00m"
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

echo
info "Provisioning server ${DEPLOY_SERVER}"

info "Copying public key to ${SUDO_USER}@${DEPLOY_SERVER}, please provide password for ${SUDO_USER}@${DEPLOY_SERVER}"
ssh-copy-id -i ${DEPLOY_PUBKEY} "${SUDO_USER}@${DEPLOY_SERVER} ${SSH_PORT_OPTIONS}"

read -s -p "Choose a password for ${DEPLOY_USER}@${DEPLOY_SERVER}: " PASSWORD
PASSWORD_HASH=$(perl -e 'print crypt($ARGV[0], "password")' ${PASSWORD})

info "Creating user ${DEPLOY_USER}@${DEPLOY_SERVER}"
ssh ${SSH_PORT_OPTIONS} ${SUDO_USER}@${DEPLOY_SERVER} "sudo useradd -m -G sudo -s /bin/bash -p ${PASSWORD_HASH} ${DEPLOY_USER}; sudo chown ${DEPLOY_USER}.${DEPLOY_USER} /home/${DEPLOY_USER}"

info "Copying public key to ${DEPLOY_USER}@${DEPLOY_SERVER}, please provide password for ${DEPLOY_USER}@${DEPLOY_SERVER}"
ssh-copy-id -i ${DEPLOY_PUBKEY} "${DEPLOY_USER}@${DEPLOY_SERVER} ${SSH_PORT_OPTIONS}"

info "Installing ruby, git, sprinkle on ${DEPLOY_SERVER}"
ssh ${SSH_PORT_OPTIONS} ${SUDO_USER}@${DEPLOY_SERVER} "sudo apt-get -y update; sudo apt-get -y install git ruby1.9.1 ruby1.9.1-dev make; sudo gem install sprinkle --no-rdoc --no-ri"

info "Cloning deploy scripts on ${DEPLOY_USER}@${DEPLOY_SERVER}"
ssh ${SSH_PORT_OPTIONS} ${DEPLOY_USER}@${DEPLOY_SERVER} "if [ -d deploy ]; then echo "deploy directory already exists, skipping git clone"; else git clone https://github.com/flexrails/deploy; fi"

info "Provisioning finished. You can now login to ${DEPLOY_USER}@${DEPLOY_SERVER} and continue using"
info "cd deploy; sudo sprinkle -c -v -s development.rb"

# TODO: why need password again?
# TODO: gen key on deployed server?
# TOOD: don't select ruby/rails version
# TODO: remove public key from root
# TODO: disable root remote login

# TODO: don't allow sudo user to ssh
# TODO: disable ssh with password
# TODO: disbale ssh as root
# TODO: only allow deploy user to ssh
# TODO: do correct permission 