#!/bin/sh

# Ensure we exit on any error
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
which redis-server >/dev/null 2>&1
if [ ! $? = 0 ]; then
  echo 'redis not found!'
  exit 1
fi
which virtualenv >/dev/null 2>&1
if [ ! $? = 0 ]; then
  echo 'virtualenv not found!'
  exit 1
fi


# Install Snake

mkdir ~/.snake
mkdir ~/.snake/cache
mkdir ~/.snake/conf
mkdir ~/.snake/db
mkdir ~/.snake/log

if [ ! -d ~/.snake/venv ]; then
  virtualenv --python=python3 ~/.snake/venv
fi

. ~/.snake/venv/bin/activate

cd snake-core
sed -i "s/ETC_DIR = '\/etc\/snake'/ETC_DIR = '~\/.snake\/conf'/" 'snake/config/constants.py'  # Override ETC_DIR to ~/.snake/conf
python setup.py install
git checkout snake/config/constants.py  # Undo override
cd ../

lines=$(find /usr/include /usr/local/include -iname fuzzy.h | wc -l)
if [ ! $lines = 0 ]; then
  pip install git+https://github.com/kbandla/pydeep
fi

cp -Rfn sys/user.conf ~/.snake/conf/snake.conf.example
if [ ! -f ~/.snake/conf/snake.conf ]; then
  cp ~/.snake/conf/snake.conf.example ~/.snake/conf/snake.conf
fi

# Install Snake Skin
cd snake-skin
npm install
npm run build
if [ -d ~/.snake-skin ]; then
  rm -Rf ~/.snake-skin
fi
mv dist ~/.snake-skin
cd ../
