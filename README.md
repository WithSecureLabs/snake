<pre>
 _   _   _   _     _   _   _   _     _   _   _   _     _           _     _   _   _   _
|_| |_| |_| |_|   |_| |_| |_| |_|   |_| |_| |_| |_|   |_|         |_|   |_| |_| |_| |_|
 _                 _           _     _           _     _           _     _
|_|               |_|         |_|   |_|         |_|   |_|         |_|   |_|
 _                 _           _     _           _     _       _         _
|_|               |_|         |_|   |_|         |_|   |_|     |_|       |_|
 _   _   _   _     _           _     _   _   _   _     _   _             _   _   _   _
|_| |_| |_| |_|   |_|         |_|   |_| |_| |_| |_|   |_| |_|           |_| |_| |_| |_|
             _     _           _     _           _     _       _         _
            |_|   |_|         |_|   |_|         |_|   |_|     |_|       |_|
             _     _           _     _           _     _           _     _
            |_|   |_|         |_|   |_|         |_|   |_|         |_|   |_|
 _   _   _   _     _           _     _           _     _           _     _   _   _   _
|_| |_| |_| |_|   |_|         |_|   |_|         |_|   |_|         |_|   |_| |_| |_| |_|

By Countercept
</pre>

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
- [snake-tail](https://github.com/countercept/snake-tail): The UNIX based command line UI (Coming Soon).

# Dependencies

There are a few dependencies to install Snake and Web UI (Snake Skin).

## Required

- (Snake) LibYAML
- (Snake) MongoDB 3.4 or greater
- (Snake) Python 3.5 or greater
- (Snake) Redis
- (Snake Skin) NodeJS
- (Snake Skin) NPM

## Optional

- (Snake) libfuzzy & ssdeep

The above can be installed on Ubuntu like so:

```bash
apt-get install libyaml-dev mongodb nodejs npm python3-dev python3-pip redis-server libfuzzy-dev ssdeep
```

# Install

There are a few ways to install Snake, but the install scripts below will install Snake and the Web UI (Snake Skin).

> Note: To install these components individually refer to their respective repositories.

## Basic

This method will install Snake and the Web UI (Snake Skin) into the home directory.

> Note: Requires virtualenv

```bash
git clone https://gitlab.countercept.mwr/alex.kornitzer/snake.git
cd snake
sys/user.sh
```

To start Snake:

```bash
# Source the virtual environment
source ~/.snake/venv/bin/activate

# Start the command workers
celery worker --app snake.worker --logfile ~/.snake/log/%n%I.log &

# Start Snake
snaked &

# Or

# Start Snake in debug mode (log to console)
snaked -d
```

To serve Snake Skin:

```bash
# Source the virtual environment
source ~/.snake/venv/bin/activate

# Navigate to Snake Skin
cd ~/.snake-skin

# Serve with http.server (port: 8000)
python -m http.server &
```

## Production

This is the preferred method and will install Snake and the Web UI (Snake Skin) into the UNIX system.

> Note: Requires nginx

```bash
git clone https://gitlab.countercept.mwr/alex.kornitzer/snake.git
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
systemctl stop nginx
systemctl start nginx
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

# Configuration

For an overview of Snake's settings, please see [Snake](https://github.com/countercept/snake-core#configuration)

For an overview of Snake Skin's settings, please see [Snake Skin](https://github.com/countercept/snake-skin)
