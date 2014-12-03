#!/bin/sh

for f in /etc/sysconfig/network-scripts/ifcfg-enp*; do
    echo "NM_CONTROLLED=no" | sudo tee -a $f
done
