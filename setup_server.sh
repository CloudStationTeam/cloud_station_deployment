#!/bin/bash
echo "######### Setting up server #########"
echo "1. Updating Ubuntu"
sudo apt-get update
sudo apt-get upgrade

echo "2. Installing NGINX and docker"
sudo apt-get install nginx
sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io

echo "3. Cloning CloudStation web app source code"
git clone https://github.com/CloudStationTeam/cloud_station_web.git ~/cloud_station_web

echo "4. Setting up Python virtual environment"
sudo apt-get install python3-venv
mkdir ~/ENV
python3 -m venv ~/ENV
source ~/ENV/bin/activate
# These dependencies are required for pymavlink
sudo apt-get install libxml2-dev libxslt-dev python-dev
pip3 install -r ~/cloud_station_web/requirements.txt --no-cache-dir

echo "Finished setting up server!"
echo "**Now, please add server IP to ALLOWED_HOSTS in cloud_station_web/webgms/settings.py**"