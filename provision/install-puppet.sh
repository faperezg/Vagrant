#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
if [[ -f /usr/bin/puppet ]]; then
    echo 'Puppet 3.4.3 already installed'
    exit 0
fi
gem install deep_merge --no-ri --no-rdoc
gem install activesupport --no-ri --no-rdoc
gem install vine --no-ri --no-rdoc
sudo apt-get -y install augeas-tools libaugeas-dev
echo 'Installing Puppet requirements'
gem install haml hiera facter json ruby-augeas deep_merge --no-ri --no-rdoc
echo 'Finished installing Puppet requirements'
echo 'Installing Puppet 3.4.3'
gem install puppet --version 3.4.3 --no-ri --no-rdoc
echo 'Finished installing Puppet 3.4.3'
sudo cat >/usr/bin/puppet << 'EOL'
#!/bin/bash
rvm ruby-1.9.3-p551 do puppet "$@"
EOL
sudo chmod +x /usr/bin/puppet
