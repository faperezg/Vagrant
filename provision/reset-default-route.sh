#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
sudo route del default
sudo route add default gw 192.168.4.1 
exit 0;
