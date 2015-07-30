#!/bin/sh

for node in $(sed -n '/<<< Packstack >>>/{:a;n;/>>> Packstack <<</b;p;ba}' /etc/hosts | grep compute | awk '{ print $2 }'); do
    ssh $node 'sudo crudini --set /etc/nova/nova.conf DEFAULT compute_driver fake.FakeDriver'
    ssh $node 'sudo systemctl restart openstack-nova-compute.service'
done
