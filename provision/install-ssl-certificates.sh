#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
if [[ -f /etc/ssl/local/apache.pem ]]; then
    echo 'SSL certificates already installed'
    exit 0
fi
echo 'Installing self-signed SSL certificates'
sudo mkdir -p /etc/ssl/local
sudo openssl req -new -x509 -days 3650 -nodes -subj "/C=VE/ST=Miranda/L=Caracas/O=CorpLaurus/CN=webconsole.corplaurus.int" -out /etc/ssl/local/apache.pem -keyout /etc/ssl/local/apache.key
sudo chmod 600 /etc/ssl/local/apache*
echo 'Finished installing self-signed SSL certificates'
