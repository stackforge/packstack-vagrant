#!/bin/sh

# https://rally.readthedocs.org/en/latest/install.html#automated-installation

cd /home/vagrant
sudo yum install -y git
git clone https://git.openstack.org/openstack/rally
sudo ./rally/install_rally.sh
rally-manage db recreate
source /home/vagrant/openrc
rally deployment create --fromenv --name=packstack
rally deployment check
