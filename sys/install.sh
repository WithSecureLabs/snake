#!/bin/bash

# Exit on any error
set -e

which git >/dev/null 2>&1
if [ ! $? = 0 ]; then
  echo 'git not found!'
  exit 1
fi

echo "Updating repository..."
git submodule init
git submodule update
git pull

# Check for dependencies

lines=$(find /usr/include /usr/local/include -name yaml.h | wc -l)
if [ $lines = 0 ]; then
  echo 'libyaml not found!'
  exit 1
fi
which mongo >/dev/null 2>&1
if [ ! $? = 0 ]; then
  echo 'mongodb not found!'
  exit 1
fi
which node >/dev/null 2>&1
if [ ! $? = 0 ]; then
  echo 'nodejs not found!'
  exit 1
fi
which npm >/dev/null 2>&1
if [ ! $? = 0 ]; then
  echo 'npm not found!'
  exit 1
fi
which python3 >/dev/null 2>&1
if [ ! $? = 0 ]; then
  echo 'python 3 not found!'
  exit 1
fi
lines=$(find /usr/include /usr/local/include -name Python.h | grep python3 | wc -l)
if [ $lines = 0 ]; then
  echo 'python 3 headers not found!'
  exit 1
fi
which pip3 >/dev/null 2>&1
if [ ! $? = 0 ]; then
  echo 'pip3 not found!'
  exit 1
fi
which redis-server >/dev/null 2>&1
if [ ! $? = 0 ]; then
  echo 'redis not found!'
  exit 1
fi


# Install Snake

cd snake-core
sudo python3 setup.py install
cd ../

lines=$(find /usr/include /usr/local/include -iname fuzzy.h | wc -l)
if [ ! $lines = 0 ]; then
  sudo -H pip3 install git+https://github.com/kbandla/pydeep
fi

SNAKE_DIR=`python3 -c 'import imp; print(imp.find_module("snake")[1])'`

# Create user
# NOTE: use the cache dir for the home folder, whats the harm
$(id -u snaked) >/dev/null || ret=$?
if [ $ret -ne 0 ]; then
  sudo useradd -r -s /sbin/nologin -d /var/cache/snake snaked
fi

# Create directories
sudo mkdir -p /var/cache/snake
sudo mkdir -p /var/db/snake
sudo mkdir -p /var/log/snake
sudo mkdir -p /var/log/snake-pit

# Handle confs
sudo cp -Rfn ${SNAKE_DIR}/data/snake /etc/snake

if [ ! -f /etc/snake/snake.conf ]; then
  sudo cp /etc/snake/snake.conf.example /etc/snake/snake.conf
fi
if [ ! -f /etc/snake/systemd/snake.conf ]; then
  sudo cp /etc/snake/systemd/snake.conf.example /etc/snake/systemd/snake.conf
fi
if [ ! -f /etc/snake/systemd/snake-pit.conf ]; then
  sudo cp /etc/snake/systemd/snake-pit.conf.example /etc/snake/systemd/snake-pit.conf
fi

# Install systemd services
sudo cp $SNAKE_DIR/data/systemd/* /etc/systemd/system
sudo cp sys/snake-skin.service /etc/systemd/system

# Address permissions
sudo chown snaked:snaked -R /etc/snake
sudo chown snaked:snaked -R /var/cache/snake
sudo chown snaked:snaked -R /var/db/snake
sudo chown snaked:snaked -R /var/log/snake
sudo chown snaked:snaked -R /var/log/snake-pit

# Enable services
sudo systemctl daemon-reload
sudo systemctl enable snake-pit
sudo systemctl enable snake

# Install Snake Skin

cd snake-skin
npm install
npm run build
if [ -d /var/www/snake-skin ]; then
  sudo rm -Rf /var/www/snake-skin
fi
sudo mkdir -p /var/www/snake-skin
sudo cp -Rf ./{node_modules,__sapper__,static} /var/www/snake-skin/

sudo systemctl enable snake-skin

cd ../
