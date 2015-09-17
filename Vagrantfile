# -*- mode: ruby -*-
$needs_provision = false

Vagrant.configure('2') do |config|
  config.vm.define "router" do |router|
    router.vm.box = "router"
    router.vm.network 'private_network', ip: "192.168.4.1", auto_config: false
    router.vm.network :forwarded_port, guest: 22, host: 65535, id: 'ssh', disabled: true
    router.vm.provider :virtualbox do |virtualbox|
      virtualbox.name = "CLVRouter"
      virtualbox.gui = "1"
      virtualbox.customize ['modifyvm', :id, "--nic2", "hostonly"]
      virtualbox.customize ['modifyvm', :id, "--hostonlyadapter2", "vboxnet0"]
    end
    router.ssh.host = "192.168.4.1"
    router.ssh.port = 22
    router.ssh.username = "fperez"
    router.ssh.private_key_path = "/home/fperez/.ssh/id_rsa"
    router.ssh.insert_key = false
  end
  
  config.vm.define "webconsole" do |webconsole|
    if ($needs_provision) then
      webconsole.vm.hostname = "webconsole.corplaurus.int"
      webconsole.vm.network 'private_network', type: "dhcp"

      webconsole.vm.provision :shell, :path => 'provision/initial-setup.sh'
      webconsole.vm.provision :shell, :path => 'provision/install-ruby.sh'
      webconsole.vm.provision :shell, :path => 'provision/install-puppet.sh'
      webconsole.vm.provision :shell, :path => 'provision/install-ssl-certificates.sh'
      webconsole.vm.provision :puppet do |puppet|
        puppet.facter = {
          'fqdn'             => "webconsole.corplaurus.int",
          'provisioner_type' => "virtualbox",
        }
        puppet.manifests_path = "provision"
        puppet.manifest_file  = "site.pp"
        puppet.module_path    = "provision/modules"
      end
    else
      webconsole.vm.network 'private_network', type: "dhcp", auto_config: false      
      webconsole.vm.provision :shell, :path => 'provision/reset-default-route.sh', run: "always"
    end

    webconsole.vm.box     = "debian-server"
    webconsole.vm.network :forwarded_port, guest: 22, host: 65534, id: 'ssh'
    webconsole.vm.synced_folder "./src", "/var/www", group: "www-data", owner: "fperez", mount_options: ['dmode=775', 'fmode=774']
    webconsole.vm.provider :virtualbox do |virtualbox|
      virtualbox.name = "WebConsole"
      virtualbox.gui = "1"
      virtualbox.customize ['modifyvm', :id, "--nic2", "hostonly"]
      virtualbox.customize ['modifyvm', :id, "--hostonlyadapter2", "vboxnet0"]
    end
    
    webconsole.ssh.username = "fperez"
    webconsole.ssh.private_key_path = "/home/fperez/.ssh/id_rsa"
    webconsole.ssh.insert_key = false
  end
end
