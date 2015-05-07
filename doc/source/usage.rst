Usage
=====


Credentials
-----------

-  The password for the OpenStack user ``admin`` in the tenant ``admin``
   is ``password``.
-  The password for the Nagios user ``nagiosadmin`` is ``password``.

Webinterfaces
-------------

-  The OpenStack Dashboard is available on the controller node, by
   default at http://10.100.50.10/dashboard/.
-  The webinterface of Nagios is available on the controller node, by
   default at http://10.100.50.10/nagios/.

CLIs
----

All command line interfaces are installed on the controller node.

APIs
----

All OpenStack API services are running on the controller node with the
default IP address ``10.100.50.10``.

Rally
-----

Install `Rally <https://github.com/openstack/rally>`_, a framework for
performance analysis and benchmarking of individual OpenStack components,
with ``/home/vagrant/scripts/rally.sh`` to ``/opt/rally``. The directory
is accessible through the webserver, by default at http://10.100.50.10/rally/.
