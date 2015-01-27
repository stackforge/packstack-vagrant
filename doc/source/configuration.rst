Configuration
=============

Copy the sample configuration file ``config.yaml.sample`` to
``config.yaml`` and adjust the file accordingly.

Base box
--------

In theory (not tested) it is possible to use RHEL or Fedora instead of
CentOS. By default the box ``centos-packstack`` will be used.

::

    box:
      name: b1-systems/centos-packstack

``centos-packstack`` is a customized version of
`boxcutter/centos70 <https://github.com/box-cutter/centos-vm>`__. The
`Packer <https://packer.io/>`__ template is available in the
`stackforge/packstack-vagrant <https://github.com/stackforge/packstack-vagrant/tree/master/packer>`__
repository and the box iself on
`Atlas <https://atlas.hashicorp.com/b1-systems/centos-packstack>`__.

To change the used base box modify the value of ``name``. A list
of public available boxes is available on
`Atlas <https://atlas.hashicorp.com/>`__.

Depending on the used base box you have to set the used storage
controller (``SATA Controller`` by default). The
storage controller of the used base box must support at least three ports.

::

    box:
      name: b1-systems/centos-packstack
      storage_controller: 'SATA Controller'


Networking
----------

Bridges
~~~~~~~

::

    bridge_internal: tap0
    bridge_external: tap1

Addresses
~~~~~~~~~

::

    netmask_internal: 255.255.0.0
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

    network_agent: openvswitch

Tenant networks
~~~~~~~~~~~~~~~

::

    network_type: gre

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
enable caching/proxying set ``use`` to ``true``.

``address`` has to point to an existing HTTP proxy server (e.g.
``http://proxy.company.site:3128``).

::

  proxy:
    use: true
    install: false
    address: 'http://proxy.company.site:3128'

To install the HTTP proxy `Squid <http://www.squid-cache.org/>`__ on the
controller node set ``install`` to ``true``.

To use the local proxy set ``use`` to ``true``.  ``address`` has not to
be set when installing Squid on the controller node. ``address`` will be
overwritten when installing Squid as local HTTP proxy.

::

  proxy:
    install: true
    use: true

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
