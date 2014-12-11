#!/bin/bash

run() {
    number=$1
    shift
    python scripts/get_hosts.py | xargs -n 1 -P $number -I BOX sh -c "echo - BOX && (vagrant $* BOX 2>&1 >> log/BOX.log)"
}

if [[ ! -e config.yaml ]]; then
    echo "error: configuration file 'config.yaml' does not exist"
    exit 1
fi

echo "$(date) cleaning up"
rm -f log/*
vagrant destroy

vagrant box list | grep packstack-template > /dev/null
if [[ $? -ne 0 ]]; then
    echo "$(date) preparing template"
    vagrant up template 2>&1 >> log/template.log
    vagrant halt template 2>&1 >> log/template.log
    vagrant package --output packstack-template.box template 2>&1 >> log/template.log
    vagrant destroy --force template 2>&1 >> log/template.log
    vagrant box add --force --name packstack-template --provider virtualbox packstack-template.box 2>&1 >> log/template.log
    rm -f packstack-template.box
fi

echo "$(date) brining up all VMs"
run 2 up --no-provision

echo "$(date) provisioning all VMs"
run 4 provision

echo "$(date) reloading all VMs"
run 4 reload

echo "$(date) initializing the controller node"
vagrant ssh controller -c '/home/vagrant/scripts/initialize.sh' 2>&1 >> log/controller.log
