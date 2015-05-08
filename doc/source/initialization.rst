Initialization
==============

::

    $ vagrant up

-  The installation log file is available at:
   ``/var/tmp/packstack/YYMMDD-HHMMSS-abcdef/openstack-setup.log``
-  The generated manifests are available at:
   ``/var/tmp/packstack/YYMMDD-HHMMSS-abcdef/manifests``

After the successful deployment you can run the ``setup.sh`` script
on the controller node as the unprivileged user ``vagrant``
(``vagrant ssh controller``)  to add cloud images etc. pp.

::

    $ /home/vagrant/scripts/setup.sh
