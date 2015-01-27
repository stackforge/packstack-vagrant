#!/bin/bash

if [[ -z "$1" ]]; then
    p=1
else
    p=$1
fi

run() {
    number=$1
    shift
    python scripts/get_hosts.py | grep -v controller | xargs -n 1 -P $number \
        -I BOX sh -c "echo - BOX && (vagrant $* BOX 2>&1 | tee -a log/BOX.log)"
}

if [[ ! -e config.yaml ]]; then
    echo "error: configuration file 'config.yaml' does not exist"
    exit 1
fi

echo "$(date) cleaning up"
rm -f log/*
vagrant destroy --force

echo "$(date) bringing up, provisioning and reloading the controller VM"
logfile=log/controller.log
vagrant up controller | tee -a $logfile
vagrant reload controller | tee -a $logfile

echo "$(date) brining up all VMs"
run $p up --no-provision

echo "$(date) provisioning all other VMs"
run $p provision

echo "$(date) reloading all other VMs"
run $p reload

echo "$(date) initializing the controller node"
logfile=log/controller.log
vagrant ssh controller -c '/home/vagrant/scripts/initialize.sh' 2>&1 | tee -a $logfile

echo "$(date) getting status of all VMs"
vagrant status
