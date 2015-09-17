# Vagrant

This is a configuration file which starts two virtual machines:

+ The router (private prepackaged). Contains everything not directly associated to my development projects. It is a Debian Wheezy server with:
  - eth0 as external network (NAT or DHCP, connects to internet). eth1 as internal network on vboxnet0 host-only network (VirtualBox)
  - Fixed IP address: 192.168.4.1
  - DHCP and DNS server with DNSMasq
  - Dovecot IMAP server
  - Postfix SMTP Server
  - Gateway
  - RoundCube web email client (required apache, php and mysql-server installation)
  - Because this VM will not change, I disabled network auto configuration and SSH port forwarding.

+ The webconsole. Will be a simple (super stupid) project used to learn some technologies. It will contain:
  - Debian Wheezy server
  - eth1 as internal network, mapped to vboxnet0 host-only network (same network as router)
  - Dynamic IP address, offered by router VM
  - Apache / MySQL server / PHP / Some PHP modules required by Symfony2
  - Composer
  - XDebug
  - PHPUnit
  - A MySQL database
  - The provisioning is done using puppet-apply
  - It is based on a VagrantFile created with http://www.puphpet.com/. Those guys are really amazing
  - When VM is completely provisioned, network autoconfig should be disabled. This is done using parameter $needs_provisioning in VagrantFile.
  - Additionally, Vagrant creates eth0 NATted network. It should not be used by the system. So, I wrote a tiny shell script which corrects routes and is executed as provisioning when $needs_provision = false

DISCLAIMER: This file was done for learning purposes of the following technologies:
+ Vagrant
+ Puppet

You can do whatever you want with this code, but if anything goes wrong, I take no responsability. Use at your own risk.
