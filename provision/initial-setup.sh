#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
if [[ -f /usr/bin/curl ]]; then
    echo 'curl, git-core and build-essential already installed'
    exit 0
fi
echo 'Running initial-setup apt-get update'
sudo apt-get update > /dev/null
echo 'Finished running initial-setup apt-get update'
sudo echo "nameserver 8.8.8.8" > /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo 'Installing curl'
sudo apt-get -y install curl > /dev/null
echo 'Finished installing curl'
echo 'Installing git'
sudo apt-get -y install git-core > /dev/null
echo 'Finished installing git'
echo 'Installing build-essential packages'
sudo apt-get -y install build-essential > /dev/null
echo 'Finished installing build-essential packages'
