Initialization
==============

First run the ``bootstrap.sh`` script to prepare all required nodes.

::

    $ ./scripts/bootstrap.sh

Afterwards run the following command on the controller node
(``vagrant ssh controller``) to deploy OpenStack with Packstack.

::

    $ packstack --answer-file packstack.answers

Run ``packstack`` with ``--debug`` to enable debug logging.

::

    $ packstack --debug --answer-file packstack.answers

-  The installation log file is available at:
   ``/var/tmp/packstack/YYMMDD-HHMMSS-abcdef/openstack-setup.log``
-  The generated manifests are available at:
   ``/var/tmp/packstack/YYMMDD-HHMMSS-abcdef/manifests``

Optionally you can run the ``setup.sh`` script after the successful
deployment to add cloud images etc. pp.

::

    $ ./scripts/setup.sh
