Requirements
============

The installation of Vagrant is documented in the `Vagrant
documentation <https://docs.vagrantup.com/v2/installation/index.html>`__.

The used provisioner is `Ansible <http://www.ansible.com>`__. To be able
to start this Vagrant environment install Ansible on the Vagrant host.

::

    $ sudo yum install -y ansible

A helper script (`scripts/get_hosts.py`) requires the Python library
`PyYAML <https://pypi.python.org/pypi/PyYAML/3.11>`__.

::

    $ sudo yum install -y PyYAML
