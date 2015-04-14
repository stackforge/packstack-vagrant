Requirements
============

Vagrant
-------

The installation of Vagrant is documented in the `Vagrant
documentation <https://docs.vagrantup.com/v2/installation/index.html>`__.
Ensure to use at least version ``1.7.2`` of Vagrant.

::

    $ vagrant --version
    Vagrant 1.7.2

Vagrant plugins
~~~~~~~~~~~~~~~

If you want to use an external HTTP proxy server for caching/proxying install
the Vagrant plugin ``vagrant-proxyconf``.

::

    $ vagrant plugin install vagrant-proxyconf

Ansible
-------

The used provisioner is `Ansible <http://www.ansible.com>`__. To be able
to start this Vagrant environment install Ansible on the Vagrant host.

::

    $ sudo yum install -y ansible
