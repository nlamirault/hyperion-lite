# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'hyperion-lite'

  config.vm.box = "coreos-324.2.0"
  config.vm.box_url = "http://storage.core-os.net/coreos/amd64-usr/324.2.0/coreos_production_vagrant.box"

  config.vm.hostname = "Hyperion-Lite"
  config.vm.network :private_network, :ip => '10.2.4.6'
  config.vm.synced_folder ".", "/home/core/hyperion", type: "rsync"
  # FIX: Virtualbox 100%CPU using it
  #config.vm.synced_folder "/var/docker/hyperion", "/var/docker/hyperion", id: "core", :nfs => true,  :mount_options   => ['nolock,vers=3,udp']

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.provider :virtualbox do |vb, override|
    # Fix docker not being able to resolve private registry in VirtualBox
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.memory = 1024
    vb.cpus = 1
    vb.name = "Hyperion-Lite"
  end

  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.provision :file, :source => "coreos/user-data", :destination => "/tmp/vagrantfile-user-data"
  config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
  config.vm.provision :file, :source => "client/hyperion.sh", :destination => "/home/core/hyperion.sh"
  config.vm.provision :file, :source => "coreos/hyperion-lite.service", :destination => "/tmp/hyperion-lite.service"
  config.vm.provision :shell, :inline => "mv /tmp/hyperion-lite.service /etc/systemd/system/hyperion-lite.service", :privileged => true
  #config.vm.provision :shell, :inline => "systemctl enable /etc/systemd/system/hyperion-lite.service", :privileged => true
  config.vm.provision :shell, :inline => "fleetctl start /etc/systemd/system/hyperion-lite.service", :privileged => true

end
