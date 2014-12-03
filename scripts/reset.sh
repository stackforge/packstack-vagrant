#!/bin/sh

vagrant destroy --force
vagrant box remove --force packstack-template
#vagrant box remove --force b1-systems/centos-packstack
