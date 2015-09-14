# -*- mode: ruby -*-

Vagrant.configure('2') do |config|
  config.vm.box     = "debian-server"
  config.vm.hostname = "webconsole.corplaurus.int"
  config.vm.network 'private_network', type: "dhcp"
  config.vm.synced_folder "./src", "/var/www", group: "www-data", owner: "fperez", mount_options: ['dmode=775', 'fmode=774']
  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.name = "WebConsole"
    virtualbox.gui = "1"
    virtualbox.customize ['modifyvm', :id, "--nic2", "hostonly"]
    virtualbox.customize ['modifyvm', :id, "--hostonlyadapter2", "vboxnet0"]
  end
  
  config.ssh.username = "fperez"
  config.ssh.private_key_path = "/home/fperez/.ssh/id_rsa"
  config.ssh.insert_key = false
  
  config.vm.provision :shell, :path => 'provision/initial-setup.sh'
  config.vm.provision :shell, :path => 'provision/install-ruby.sh'
  config.vm.provision :shell, :path => 'provision/install-puppet.sh'
  config.vm.provision :shell, :path => 'provision/install-ssl-certificates.sh'

  config.vm.provision :puppet do |puppet|
    puppet.facter = {
      'fqdn'             => "webconsole.corplaurus.int",
      'provisioner_type' => "virtualbox",
    }
    puppet.manifests_path = "provision"
    puppet.manifest_file  = "site.pp"
    puppet.module_path    = "provision/modules"
  end
end
