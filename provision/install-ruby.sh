#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
if [[ -f /usr/local/rvm/bin/rvm ]]; then
    echo 'RVM and Ruby 1.9.3 already installed'
    exit 0
fi
echo 'Installing RVM and Ruby 1.9.3'
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --quiet-curl --ruby=ruby-1.9.3-p551
source /usr/local/rvm/scripts/rvm
if [[ -f '/root/.bashrc' ]] && ! grep -q 'source /usr/local/rvm/scripts/rvm' /root/.bashrc; then
    echo 'source /usr/local/rvm/scripts/rvm' >> /root/.bashrc
fi
if [[ -f '/etc/profile' ]] && ! grep -q 'source /usr/local/rvm/scripts/rvm' /etc/profile; then
    echo 'source /usr/local/rvm/scripts/rvm' >> /etc/profile
fi

/usr/local/rvm/bin/rvm cleanup all
gem update --system >/dev/null
echo 'y' | rvm rvmrc warning ignore all.rvmrcs
echo 'Finished installing RVM and Ruby 1.9.3'
