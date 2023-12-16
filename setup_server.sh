#!/bin/bash 

echo "######### Setting up server #########"
echo "For Amazon Web Services (AWS) Amazon Machine Image (AMI) Linux Ubuntu Server 22.04 LTS (HVM)"

echo "1. Updating Ubuntu"
# Update package database
sudo apt-get update -y

# Set non-interactive frontend for apt (this will avoid prompts during the upgrade)
export DEBIAN_FRONTEND=noninteractive

# Upgrade packages
sudo apt-get upgrade -y

# Configure needrestart to automatically restart services
echo -e "\$nrconf{restart} = 'a';" | sudo tee -a /etc/needrestart/needrestart.conf > /dev/null

# Run needrestart to check if a restart is needed and handle it as per configuration
sudo needrestart

echo "2. Installing NGINX and docker"
echo "Installing NGINX"
sudo apt-get --yes install nginx

echo "Removing any old Docker installations"
sudo apt-get --yes remove docker docker-engine docker.io containerd runc

echo "Cleaning up unnecessary packages and cache"
sudo apt-get autoremove --yes
sudo apt clean
sudo apt update

echo "Installing dependencies for Docker installation"
sudo apt-get --yes install apt-transport-https ca-certificates curl gnupg lsb-release
sudo apt-get update

echo "Adding Docker's official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Once the key is imported, update your package lists:
sudo apt-get update

echo "Setting up the Docker stable repository"
#echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt --yes install docker.io

echo "Updating package lists to include Docker packages from the new repository"
sudo apt-get update

echo "Installing Docker CE, Docker CE CLI, and containerd.io"
#sudo apt-get install docker-ce docker-ce-cli containerd.io
bash ./docker.sh

echo "Updating package lists"
sudo apt-get update

echo "3. Cloning CloudStation web app source code"
git clone https://github.com/CloudStationTeam/cloud_station_web.git

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
sudo apt-get update
sudo apt-get --yes install libxml2-dev libxslt-dev python3-dev
sudo apt-get --yes install libffi-dev
sudo apt-get --yes install python3-lxml #Now install python3-lxml
sudo apt-get update

# It's a good practice to check if an installation command was successful before proceeding
if [ $? -ne 0 ]; then
    echo "Dependency installation failed 1"
    exit 1
fi

# Update pip, setuptools, and wheel to their latest versions
pip3 install --upgrade pip setuptools wheel
# Install requirements from your requirements.txt file without using cache
# If encounter errors, update some packages in ~/cloud_station_web/requirements.txt to the latest versions 
# For example, pymavlink 
# Instead of downgrade setuptools 
pip3 install -r ~/cloud_station_web/requirements.txt --no-cache-dir

# Check if the pip installations were successful
if [ $? -ne 0 ]; then
    echo "Pip installation failed 2"
    exit 1
fi

# git config --global core.editor "vim"
echo "Finished setting up server!"
echo "**Now, please add server IP to ALLOWED_HOSTS in cloud_station_web/webgms/settings.py**"


