#!/bin/bash 

echo "######### Setting up server #########"
echo "For Amazon Web Services (AWS) Amazon Machine Image (AMI) Linux Ubuntu Server 22.04 LTS (HVM)"

echo "1. Updating Ubuntu"
# Update package database
sudo apt-get update -y

# Configure needrestart to automatically restart services
sudo sed -i 's/^#\$nrconf{restart}.*$/$nrconf{restart} = '\''a'\'';/' /etc/needrestart/needrestart.conf

# Upgrade packages
sudo apt-get upgrade -y

# Install EMACS, Professor Burke's favorite text editor
sudo apt-get install emacs -y
sudo apt-get install emacs -y

echo "2. Installing NGINX and docker"
echo "Installing NGINX"
sudo apt-get --yes install nginx

echo "Removing any old Docker installations"
sudo apt-get --yes remove docker docker-engine docker.io containerd runc

echo "Installing dependencies for Docker installation"
sudo apt-get --yes install apt-transport-https ca-certificates curl gnupg lsb-release

echo "Adding Docker's official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "Setting up the Docker stable repository"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker CE, Docker CE CLI, and containerd.io"
sudo apt --yes install docker.io
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
#bash ./docker.sh Legacy from v 3.0. But file docker.sh not here yet, why run it now?

# Temporary clone the dev branch
echo "3. Cloning CloudStation web app source code"
#git clone https://github.com/CloudStationTeam/cloud_station_web.git
git clone https://github.com/CloudStationTeam/cloud_station_web.git --branch dev --single-branch

# Checkout release if specified Temporary removed until dev branch committed to release.
#for arg in "$@"
#do
#    case $arg in
#        --tag=*)
#		TAG="${arg#*=}"
#		echo "Checkout out release $TAG"
#		cd ~/cloud_station_web
#       git checkout $TAG
#        cd ~
#        shift # Remove --cache= from processing
#        ;;
#        *)
#        shift # Remove generic argument from processing
#        ;;
#    esac
#done

echo "4. Setting up Python virtual environment"
sudo apt-get --yes install python3-venv
mkdir ~/ENV
python3 -m venv ~/ENV # Creates python virtual environment.
source ~/ENV/bin/activate # Activates python virtual environment.

# These dependencies are required for pymavlink
sudo apt-get --yes install libxml2-dev libxslt-dev python3-dev
sudo apt-get --yes install libffi-dev
sudo apt-get --yes install python3-lxml #Now install python3-lxml

# Install requirements from your requirements.txt file without using cache
pip3 install -r ~/cloud_station_web/requirements.txt --no-cache-dir

echo "Finished setting up server!"
echo "**Now, please add server IP to ALLOWED_HOSTS in cloud_station_web/webgms/settings.py**"


