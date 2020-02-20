#!/bin/bash

####################### 
# READ ONLY VARIABLES #
#######################

readonly OPENSHIFT_LETSENCRYPT_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#################### 
# GLOBAL VARIABLES #
####################

FLAG_DRYRUN=false

########## 
# SOURCE #
##########

for functionFile in ${SCRIPT_HOME}/bash-script-collection/functions/*.sh; do 
  source ${functionFile} >/dev/null 2>&1
done

# __openshift-letsencrypt-create-aws-dir
function __openshift-letsencrypt-create-aws-dir () {
  if [ ! -d "$(echo ~/.aws)" ]; then
    execute "mkdir -p $(echo ~)/.aws"
  fi
}
readonly -f __openshift-letsencrypt-create-aws-dir
[ "$?" -eq "0" ] || return $?

# openshift-letsencrypt
function openshift-letsencrypt () {
  __openshift-letsencrypt-create-aws-dir
  execute "\
    docker run --rm -it -e TZ=Europe/Vienna \
      -v ${OPENSHIFT_LETSENCRYPT_HOME}:/mnt/openshift \
      -v $(echo ~)/.aws:/root/.aws \
      -v $(echo ~)/.kube/:/root/.kube:ro \
      gepardec/openshift-letsencrypt $*"
}
readonly -f openshift-letsencrypt
[ "$?" -eq "0" ] || return $?

# openshift-letsencrypt-build
function openshift-letsencrypt-build () {
  execute "docker build -t gepardec/openshift-letsencrypt $@ ${OPENSHIFT_LETSENCRYPT_HOME}"
}
readonly -f openshift-letsencrypt-build
[ "$?" -eq "0" ] || return $?

# openshift-letsencrypt-issue
function openshift-letsencrypt-issue () {
  __openshift-letsencrypt-create-aws-dir
  execute "\
    docker run --rm -it -e TZ=Europe/Vienna \
      -v ${OPENSHIFT_LETSENCRYPT_HOME}:/mnt/openshift \
      -v $(echo ~)/.aws:/root/.aws \
      -v $(echo ~)/.kube/:/root/.kube:ro \
      gepardec/openshift-letsencrypt \
      /mnt/openshift/scripts/letsencrypt-issue $*"
}
readonly -f openshift-letsencrypt-issue
[ "$?" -eq "0" ] || return $?

# openshift-letsencrypt-install
function openshift-letsencrypt-install () {
  __openshift-letsencrypt-create-aws-dir
  execute "\
    docker run --rm -it -e TZ=Europe/Vienna \
      -v ${OPENSHIFT_LETSENCRYPT_HOME}:/mnt/openshift \
      -v $(echo ~)/.kube/:/root/.kube:ro \
      gepardec/openshift-letsencrypt \
      /mnt/openshift/scripts/letsencrypt-install $*"
}
readonly -f openshift-letsencrypt-install
[ "$?" -eq "0" ] || return $?

# openshift-letsencrypt-renew
function openshift-letsencrypt-renew () {
  __openshift-letsencrypt-create-aws-dir
  execute "\
    docker run --rm -it -e TZ=Europe/Vienna \
      -v ${OPENSHIFT_LETSENCRYPT_HOME}:/mnt/openshift \
      -v $(echo ~)/.kube/:/root/.kube:ro \
      gepardec/openshift-letsencrypt \
      /mnt/openshift/scripts/letsencrypt-renew $*"
}
readonly -f openshift-letsencrypt-renew
[ "$?" -eq "0" ] || return $?

# openshift-letsencrypt-cron
function openshift-letsencrypt-cron () {
  __openshift-letsencrypt-create-aws-dir
  execute "\
    docker run --rm -it -e TZ=Europe/Vienna \
      -v ${OPENSHIFT_LETSENCRYPT_HOME}:/mnt/openshift \
      -v $(echo ~)/.kube/:/root/.kube:ro \
      -v $(echo ~)/.aws:/root/.aws \
      gepardec/openshift-letsencrypt \
      /mnt/openshift/scripts/letsencrypt-cron $*"
}
readonly -f openshift-letsencrypt-cron
[ "$?" -eq "0" ] || return $?

# openshift-letsencrypt-setup
function openshift-letsencrypt-setup () {
  openshift-letsencrypt-issue
  openshift-letsencrypt-install
  openshift-letsencrypt-cron
}
readonly -f openshift-letsencrypt-setup
[ "$?" -eq "0" ] || return $?