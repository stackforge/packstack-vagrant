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
    vb.customize ['modifyvm', :id, '--memory', CONFIG['resources']['memory']]
    vb.customize ['modifyvm', :id, '--cpus', CONFIG['resources']['vcpus']]
    vb.customize ['modifyvm', :id, '--largepages', 'on']
    vb.customize ['modifyvm', :id, '--pae', 'off']
  end
  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'playbook.yaml'
    ansible.extra_vars = {
      install_proxy: CONFIG['proxy']['install'],
      storage_backend: CONFIG['storage_backend']
    }
  end

  if CONFIG['proxy']['use'] && Vagrant.has_plugin?('vagrant-proxyconf')
    if CONFIG['proxy']['install']
      config.proxy.http  = "http://#{CONFIG['address']['controller']}:3128/"
    else
      config.proxy.http  = CONFIG['proxy']['address']
    end
    config.proxy.no_proxy = 'localhost,127.0.0.1'
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  CONFIG['address']['compute'].each_with_index do |address, index|
    name = "compute#{index + 1}"
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network :public_network,
                      ip: address,
                      netmask: CONFIG['netmask_internal'],
                      bridge: CONFIG['bridge_internal']
      node.vm.network :private_network,
                      ip: "10.0.0.2#{index}",
                      virtualbox__intnet: 'tunnel'
    end
  end

  %w(network storage).each do |name|
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network :public_network,
                      ip: CONFIG['address'][name],
                      netmask: CONFIG['netmask_internal'],
                      bridge: CONFIG['bridge_internal']
      if name == 'network'
        node.vm.network :private_network,
                        ip: '10.0.0.30',
                        virtualbox__intnet: 'tunnel'
        node.vm.network :public_network,
                        bridge: CONFIG['bridge_external'],
                        auto_config: false
      elsif name == 'storage'
        add_block_device(node, 1, CONFIG['resources']['storage'])
      end
    end
  end

  config.vm.define 'controller', primary: true do |node|
    node.vm.hostname = 'controller'
    node.vm.network :public_network,
                    ip: CONFIG['address']['controller'],
                    netmask: CONFIG['netmask_internal'],
                    bridge: CONFIG['bridge_internal']
    node.vm.provider 'virtualbox' do |vb|
      memory = CONFIG['resources']['memory'] * 2
      vcpus = CONFIG['resources']['vcpus'] * 2
      vb.customize ['modifyvm', :id, '--memory', memory]
      vb.customize ['modifyvm', :id, '--cpus', vcpus]
    end
    add_block_device(node, 1, CONFIG['resources']['storage'])
    add_block_device(node, 2, CONFIG['resources']['storage'])
    if CONFIG['proxy']['install'] && CONFIG['proxy']['use']
      node.proxy.enabled = false
    end
  end
end
