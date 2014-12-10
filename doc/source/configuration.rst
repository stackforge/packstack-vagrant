Configuration
=============

Copy the sample configuration file ``config.yaml.sample`` to
``config.yaml`` and adjust the file accordingly.

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
      nfs: 10.100.50.41
      network: 10.100.50.30
      shared: 10.100.50.50
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

Vagrant base box
----------------

In theory (not tested) it is possible to use RHEL or Fedora instead of
CentOS. Default is ``b1-systems/centos-packstack``, a customized
Vagrantbox based on
`boxcutter/centos70 <https://github.com/box-cutter/centos-vm>`__. The
sources of the used `Packer <https://packer.io/>`__ template is
available on `Github <https://github.com/b1-systems/packer-templates>`__
and the box iself on
`Atlas <https://atlas.hashicorp.com/b1-systems/centos-packstack>`__.

To change the used Vagrant base box modify the value of ``box``. A list
of public available Vagrant boxes is available on
`Atlas <https://atlas.hashicorp.com/>`__.

Depending on the used base box you have to set the used storage
controller (normally ``IDE Controller`` or ``SATA Controller``). The
storage controller of the base box must support at least three ports.

Storage backend
---------------

At the moment NFS is the only supported storage backend. Support for
Ceph will be added in the future (at the moment Ceph is not supported as
a storage backend in Packstack).

Timezone
--------

At the moment it is not possible to configure the timezone with
Packstack.

Caching
-------

To speed up the provisioning the Vagrant plugin
`vagrant-cachier <https://github.com/fgrehm/vagrant-cachier>`__
can be used.

::

    $ vagrant plugin install vagrant-cachier

When the plugin is installed caching is enabled by default. To explicitly
disable caching when the plugin is installed set ``use_cache: false``.
