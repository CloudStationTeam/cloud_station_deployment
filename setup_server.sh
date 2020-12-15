#!/bin/bash
echo "######### Setting up server #########"
echo "1. Updating Ubuntu"
sudo apt-get --yes update
sudo apt-get --yes upgrade

echo "2. Installing NGINX and docker"
sudo apt-get --yes install nginx
sudo apt-get --yes remove docker docker-engine docker.io
sudo apt --yes install docker.io

echo "3. Cloning CloudStation web app source code"
git clone https://github.com/CloudStationTeam/cloud_station_web.git ~/cloud_station_web

# Checkout release if specified
for arg in "$@"
do
    case $arg in
        --tag=*)
		TAG="${arg#*=}"
		echo "Checkout out release $TAG"
		cd ~/cloud_station_web
        git checkout $TAG
        cd ~
        shift # Remove --cache= from processing
        ;;
        *)
        shift # Remove generic argument from processing
        ;;
    esac
done

echo "4. Setting up Python virtual environment"
sudo apt-get --yes install python3-venv
mkdir ~/ENV
python3 -m venv ~/ENV
source ~/ENV/bin/activate
# These dependencies are required for pymavlink
sudo apt-get --yes install libxml2-dev libxslt-dev python3-dev
pip3 install -r ~/cloud_station_web/requirements.txt --no-cache-dir
# git config --global core.editor "vim"
echo "Finished setting up server!"
echo "**Now, please add server IP to ALLOWED_HOSTS in cloud_station_web/webgms/settings.py**"