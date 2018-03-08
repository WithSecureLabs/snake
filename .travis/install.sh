#!/bin/bash
set -ev

# Do the dependencies
sudo apt-get -y install curl
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get update
sudo apt-get -y install libyaml-dev mongodb-org nodejs python3-dev python3-pip redis-server libfuzzy-dev ssdeep nginx
sudo -H pip3 install --upgrade pip setuptools

# Make sure services are running
sudo systemctl start mongod
sudo systemctl start redis

# Try and install
sys/install.sh

# Check the install
sudo systemctl start snake-pit
sudo systemctl start snake
sudo systemctl stop nginx
sudo systemctl start nginx

# Wait
sleep 10

# Use curl to test
curl 'http://127.0.0.1:5000/api'
curl 'http://127.0.0.1:8000'

# Exit cleanly
exit 0
