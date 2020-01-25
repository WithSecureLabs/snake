![banner](https://github.com/countercept/snake/raw/master/images/banner.png)

# Introduction

Snake is a malware storage zoo that was built out of the need for a centralised and unified storage solution for malicious samples that could seamlessly integrate into the investigation pipeline.

Snake is designed to provide just enough information to allow analysts to quickly and efficiently pivot to the most suitable tools for the task at hand.
That being said there will be times where the information provided by Snake is more than sufficient.
It is a Python based application built on top of Tornado and MongoDB.
Scales provide Snake with a variety of functionality from static analysis through to interaction with external services.

For more information, please see: [Wiki](https://github.com/countercept/snake-core/wiki)

# The Snake Family

There is more to Snake than just the above, below is a summary:

- [snake](https://github.com/countercept/snake-core): The malware storage zoo.
  - core: The main guts of Snake and the RESTful API.
  - pit: The celery based workers that are used to execute static based commands.
- [snake-charmer](https://github.com/countercept/snake-charmer): The regression based test suite.
- [snake-scales](https://github.com/countercept/snake-scales): The official repository of snake scales (plugins).
- [snake-skin](https://github.com/countercept/snake-skin): The Web UI.
- [snake-tail](https://github.com/countercept/snake-tail): The UNIX based command line UI.

# Install

There are a few ways to install Snake, but the install scripts below will install Snake and the Web UI (Snake Skin).

> Note: To install these components individually refer to their respective repositories.

## Docker

Snake can be run simply with the following commands:

```bash
# Get the lastest version of Snake
git clone https://github.com/countercept/snake.git
git submodule init
git submodule update

# Run Snake
sudo docker-compose up
```

Snake scales can be installed by exec'ing into the Snake container and running `snake install`:

```bash
# Exec into the Snake container
sudo docker exec -it snake_snake_1 /entrypoint.sh /bin/bash

# Install a scale
snake install SCALE_NAME
```

## Production

This is the preferred method and will install Snake and the Web UI (Snake Skin) into the UNIX system.

### Dependencies

There are a few dependencies to install Snake and Web UI (Snake Skin).

### Required

- (Snake) LibYAML
- (Snake) MongoDB 3.4 or greater
- (Snake) Python 3.5 or greater
- (Snake) Redis
- (Snake Skin) NodeJS 8 or greater
- (Snake Skin) NPM

#### Optional

- (Snake) libfuzzy & ssdeep

The above can be installed like so:

`Ubuntu 17.10`
```bash
# Install dependencies
sudo apt-get install libyaml-dev mongodb nodejs npm python3-dev python3-pip redis-server libfuzzy-dev ssdeep
```

`Ubuntu 16.04`
```bash
# Install cURL
sudo apt-get install curl

# Add repository for MongoDB 3.6
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list

# Add repository for nodejs 8
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

# Install dependencies
sudo apt-get update
sudo apt-get install libyaml-dev mongodb-org nodejs python3-dev python3-pip redis-server libfuzzy-dev ssdeep

# Update pip and setuptools
sudo -H pip3 install --upgrade pip setuptools
```

```bash
git clone https://github.com/countercept/snake.git
cd snake
sys/install.sh
```

To start Snake:

```bash
# Start Snake Pit and Snake services
systemctl start snake-pit
systemctl start snake
```

To serve Snake Skin (port: 8000):

```bash
# Start Nginx to host Snake Skin
systemctl start snake-skin
```

# Scales (Plugins)

By default Snake only provides three core scales:

- hashes: a command based scale used to perform a variety of hashing techniques on a sample.
- strings: a command based module to run strings on a sample.
- url: an upload based component used to upload samples to Snake from URLs.

## Installing Additional Scales

Additional Scales are available at [snake-scales](https://github.com/countercept/snake-scales)

Snake provides a wrapper around pip to ease the installation of scales.
A scale can be installed with this utility like so:
```bash
snake install virustotal
```

A scale can be checked at any time to see if it will successfully load in Snake.
```bash
snake check virustotal
```

> Note: Whenever a new scale is installed, Snake and Celery must be restarted.

To create a scale, please see [Scale Documentation](https://github.com/countercept/snake-core/wiki/scales)

# Usage

Both installations will serve Snake on port 5000 (API) and Snake Skin on port 8000.

To communicate with the WebUI:

```bash
Visit http://127.0.0.1:8000
```

To communicate with the API:

```bash
curl http://127.0.0.1:5000
```

# Screenshots

## Details View

An overview of a sample that has been uploaded to Snake, with additional data enrichment from Cuckoo and VirusTotal.

![details](https://github.com/countercept/snake/raw/master/images/details.png)

## Notes View

Stores an user written notes about the sample.

![notes](https://github.com/countercept/snake/raw/master/images/notes.png)

## Analysis View

This view is used to execute and view commands on a sample.

![analysis](https://github.com/countercept/snake/raw/master/images/analysis.png)

## Interfaces View

This view is used to communicate with external services in relation to a sample.

![interfaces](https://github.com/countercept/snake/raw/master/images/interfaces.png)


# Configuration

For an overview of Snake's settings, please see [Snake](https://github.com/countercept/snake-core#configuration)

For an overview of Snake Skin's settings, please see [Snake Skin](https://github.com/countercept/snake-skin)
