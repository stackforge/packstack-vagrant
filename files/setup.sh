#!/bin/sh

source /home/vagrant/openrc

glance image-create --name "Fedora 21" --disk-format qcow2 --container-format bare --is-public True --copy http://download.fedoraproject.org/pub/fedora/linux/releases/21/Cloud/Images/x86_64/Fedora-Cloud-Base-20141203-21.x86_64.qcow2
glance image-create --name "Ubuntu 14.04" --disk-format qcow2 --container-format bare --is-public True --copy https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img
glance image-create --name "CentOS 7" --disk-format qcow2 --container-format bare --is-public True --copy http://cloud.centos.org/centos/7/devel/CentOS-7-x86_64-GenericCloud.qcow2
glance image-create --name "Cirros 0.3.3" --disk-format qcow2 --container-format bare --is-public True --copy http://download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img
glance image-create --name "Debian Jessie" --disk-format qcow2 --container-format bare --is-public True --copy http://cdimage.debian.org/cdimage/openstack/testing/debian-testing-openstack-amd64.qcow2
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova keypair-add --pub_key /home/vagrant/.ssh/id_rsa.pub default
neutron net-create internal001
neutron subnet-create --name internal001 internal001 192.168.200.0/24
neutron router-create internal001
neutron router-interface-add internal001 internal001
neutron net-create external001 --shared --router:external True --provider:physical_network external --provider:network_type flat
neutron subnet-create external001 --name external001 --allocation-pool start=203.0.113.100,end=203.0.113.200 --disable-dhcp --gateway 203.0.113.1 203.0.113.0/24
neutron router-gateway-set internal001 external001
