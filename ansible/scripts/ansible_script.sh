#!/bin/bash
apt-get update -y
apt-get install -y software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible