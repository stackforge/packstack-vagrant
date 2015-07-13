Configuration
=============

Copy the sample configuration file ``config.yaml.sample`` to
``config.yaml`` and adjust the file accordingly.

Base box
--------

In theory (not tested) it is possible to use RHEL or Fedora instead of
CentOS. By default the box ``boxcutter/centos71`` will be used.

::

    box:
      name: boxcutter/centos71

To change the used base box modify the value of ``name``. A list
of public available boxes is available on
`Atlas <https://atlas.hashicorp.com/>`__.

Depending on the used base box you have to set the used storage
controller (``SATA Controller`` by default). The
storage controller of the used base box must support at least three ports.

::

    box:
      name: boxcutter/centos71
      storage_controller: 'SATA Controller'


Networking
----------

Internal network
~~~~~~~~~~~~~~~~

::

    network:
      internal:
        bridge: tap0
        netmask: 255.255.0.0
        broadcast: 10.100.255.255
        gateway: 10.100.0.1
        dns1: 208.67.222.222
        dns2: 208.67.220.220

Addresses
~~~~~~~~~

::

    address:
      controller: 10.100.50.10
      network: 10.100.50.30
      storage: 10.100.50.40
      compute:
      - 10.100.50.20
      - 10.100.50.21

To increase the number of compute nodes add more addresses to the
``compute`` list.

L2 agent
~~~~~~~~

::

    network:
      agent: openvswitch

Tenant networks
~~~~~~~~~~~~~~~

::

    network:
      type: gre

Clock synchronization (NTP)
---------------------------

Accurate clocks on every node are very important. Default is the the
usage of the `NTP Pool Project <http://www.pool.ntp.org/en/use.html>`__.

::

    ntp:
    - 0.pool.ntp.org
    - 1.pool.ntp.org
    - 2.pool.ntp.org
    - 3.pool.ntp.org

Resources
---------

Default resources defined in ``~/.vagrant.d/Vagrantfile`` or the
``Vagrantfile`` provided by the base box will be overwritten. Resources
assigned to the controller node will be multiplied by two and additional
block storage devices will be attached to the controller and NFS nodes.

::

    resources:
      memory: 4096
      vcpus: 2
      storage: 65536

Development version
-------------------

To use the development version (``master``) of Packstack set
``development: true``.

Debug mode
----------

To enable the debug mode for the deployed services set ``debug: true``.

Storage backend
---------------

At the moment NFS is the only supported storage backend. Support for
Ceph will be added in the future (at the moment Ceph is not supported as
a storage backend in Packstack).

Timezone
--------

At the moment it is not possible to configure the timezone with
Packstack.

Caching / Proxying
------------------

To speed up the provisioning the Vagrant plugin
`vagrant-proxyconf <https://github.com/tmatilai/vagrant-proxyconf/>`__
configures a HTTP proxy to be used by ``yum``.

::

    $ vagrant plugin install vagrant-proxyconf

When the plugin is installed caching/proxying is not enabled by default. To
enable caching/proxying ``proxy`` has to point to an existing HTTP proxy
server.

::

  proxy: http://proxy.company.site:3128

Components
----------

It is possible to enable or disable the components ``ceilometer``, ``cinder``,
``heat``, ``horizon``, ``ironic``, ``nagios``, ``sahara``, ``swift``,
``tempest``, and ``trove``.

For example to disable the component ``heat`` set ``heat`` to ``false``.

For example to enable the component ``trove`` set ``trove`` to ``true``.

::

  components:
    ceilometer: true
    cinder: true
    heat: true
    horizon: true
    ironic: false
    nagios: true
    sahara: false
    swift: true
    tempest: false
    trove: false

Passwords and tokens
--------------------

For simplification ``packstack-vagrant`` uses the same secret for all used
passwords and tokens. By default this secret is ``password``. To change the
secret change the value of the parameter ``secret``.

::

  secret: password
