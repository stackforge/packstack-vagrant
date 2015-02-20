Initialization
==============

::

    $ vagrant up

Afterwards run the following command on the controller node as the
unprivileged user ``vagrant`` (``vagrant ssh controller``)
to deploy OpenStack with Packstack.

::

    $ packstack --answer-file packstack.answers

Run ``packstack`` with ``--debug`` to enable debug logging.

::

    $ packstack --debug --answer-file packstack.answers

-  The installation log file is available at:
   ``/var/tmp/packstack/YYMMDD-HHMMSS-abcdef/openstack-setup.log``
-  The generated manifests are available at:
   ``/var/tmp/packstack/YYMMDD-HHMMSS-abcdef/manifests``

Finally (optional) you can run the ``setup.sh`` script after the successful
deployment to add cloud images etc. pp.

::

    $ ./scripts/setup.sh
