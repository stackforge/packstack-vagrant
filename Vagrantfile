# -*- mode: ruby -*-
# vi: set ft=ruby :

# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

require 'yaml'

unless defined? CONFIG
  configuration_file = File.join(File.dirname(__FILE__), 'config.yaml')
  CONFIG = YAML.load(File.open(configuration_file, File::RDONLY).read)
end

CONFIG['box'] = {} unless CONFIG.key?('box')
CONFIG['box']['name'] = 'b1-systems/centos-packstack' unless CONFIG['box'].key?('name')
CONFIG['box']['storage_controller'] = 'SATA Controller' unless CONFIG['box'].key?('storage_controller')

def add_block_device(node, port, size)
  node.vm.provider 'virtualbox' do |vb|
    vb.customize ['createhd', '--filename', "#{node.vm.hostname}_#{port}.vdi",
                  '--size', size]
    vb.customize ['storageattach', :id, '--storagectl',
                  CONFIG['box']['storage_controller'], '--port', port,
                  '--device', 0, '--type', 'hdd', '--medium',
                  "#{node.vm.hostname}_#{port}.vdi"]
  end
end

Vagrant.configure(2) do |config|
  config.vm.box = CONFIG['box']['name']
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.provider 'virtualbox' do |vb|
    vb.memory = CONFIG['resources']['memory']
    vb.cpus = CONFIG['resources']['vcpus']
    vb.customize ['modifyvm', :id, '--largepages', 'on']
    vb.customize ['modifyvm', :id, '--pae', 'off']
  end
  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'playbook.yaml'
    ansible.extra_vars = {
      storage_backend: CONFIG['storage_backend']
    }
  end

  if Vagrant.has_plugin?('vagrant-proxyconf') &&
     CONFIG['proxy'] != 'http://proxy.dummy.site:3128'
    config.proxy.enabled = true
    config.proxy.http  = CONFIG['proxy']
    config.proxy.no_proxy = 'localhost,127.0.0.1'
  end

  config.vbguest.auto_update = false if Vagrant.has_plugin?('vagrant-vbguest')

  CONFIG['address']['compute'].each_with_index do |address, index|
    name = "compute#{index + 1}"
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network :private_network,
                      ip: "10.0.0.2#{index}",
                      virtualbox__intnet: 'tunnel'
      node.vm.network :public_network,
                      ip: address,
                      netmask: CONFIG['network']['internal']['netmask'],
                      bridge: CONFIG['network']['internal']['bridge']
    end
  end

  config.vm.define 'network' do |node|
    node.vm.hostname = 'network'
    node.vm.network :private_network,
                    ip: '10.0.0.30',
                    virtualbox__intnet: 'tunnel'
    node.vm.network :public_network,
                    bridge: CONFIG['network']['internal']['bridge'],
                    auto_config: false
  end

  config.vm.define 'storage' do |node|
    node.vm.hostname = 'storage'
    node.vm.network :public_network,
                    ip: CONFIG['address']['storage'],
                    netmask: CONFIG['network']['internal']['netmask'],
                    bridge: CONFIG['network']['internal']['bridge']
    add_block_device(node, 1, CONFIG['resources']['storage'])
    add_block_device(node, 2, CONFIG['resources']['storage'])
    add_block_device(node, 3, CONFIG['resources']['storage'])
  end

  config.vm.define 'controller', primary: true do |node|
    node.vm.hostname = 'controller'
    node.vm.network :public_network,
                    ip: CONFIG['address']['controller'],
                    netmask: CONFIG['network']['internal']['netmask'],
                    bridge: CONFIG['network']['internal']['bridge']
    node.vm.provider 'virtualbox' do |vb|
      memory = CONFIG['resources']['memory'] * 2
      vcpus = CONFIG['resources']['vcpus'] * 2
      vb.customize ['modifyvm', :id, '--memory', memory]
      vb.customize ['modifyvm', :id, '--cpus', vcpus]
    end
    node.vm.provision 'shell', path: 'scripts/initialize.sh', privileged: false
  end
end
