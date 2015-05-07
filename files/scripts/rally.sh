#!/bin/sh

# https://rally.readthedocs.org/en/latest/install.html#automated-installation

cd /opt
sudo yum install -y git
sudo git clone https://git.openstack.org/openstack/rally
sudo chown -R vagrant:vagrant rally
sudo ./rally/install_rally.sh
rally-manage db recreate
source /home/vagrant/openrc
rally deployment create --fromenv --name=packstack
rally deployment check

cat <<EOT | sudo tee /etc/httpd/conf.d/rally.conf
Alias /rally "/opt/rally"
<Directory "/opt/rally">
  Options +Indexes
  AllowOverride None
  Require all granted
</Directory>
EOT

sudo sed -i "s#</VirtualHost>#  Include /etc/httpd/conf.d/rally.conf\n</VirtualHost>#" /etc/httpd/conf.d/15-horizon_vhost.conf
sudo systemctl restart httpd
