#!/bin/bash 

# Define function first


function inputMapBoxkeyandInsertintosettings {
    read -p "To begin with the installation type in the mapbox key:" mbkey

    echo "You entered:"
    echo $mbkey

    read -p "If this is correct, enter "yes": " out

    if ! [ "$out" = "yes" ]
    then
        echo "You did not type in 'yes'. Exiting....Mapbox key not in yet. Please check documentation."
        exit 1
    fi
    
    
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

    echo "Editing settings.py to put Mapbox key in that you entered above."

    # mbkey was entered above
    #sed -i 's/=""/="$mbkey"/g' ~/cloud_station_web/webgms/settings.py
    sed -i "s/=\"\"/=\"$mbkey\"/g" ~/cloud_station_web/webgms/settings.py
    #sed -i "s/=\"\"/=\"$var\"/g" your_file
}


function inputGoogleMapsKeyandSaveToEnv {
    read -p "To begin with the installation type in the google maps key:" gmkey

    echo "You entered:"
    echo $gmkey

    read -p "If this is correct, enter "yes": " out

    if ! [ "$out" = "yes" ]
    then
        echo "You did not type in 'yes'. Exiting....Google maps key not in yet. Please check documentation."
        exit 1
    fi
    
    
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

    echo "Editing ~/cloud_station_web/.env to put google maps key in that you entered above."

    touch ~/cloud_station_web/.env
    echo GOOGLE_MAP_API_KEY=$gmkey>~/cloud_station_web/.env
}



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

# use https://stackoverflow.com/questions/71393595/installing-docker-in-ubuntu-from-repo-cant-find-a-repo
sudo apt-get update
     
echo "Installing dependencies for Docker installation"
sudo apt-get --yes install apt-transport-https ca-certificates curl gnupg lsb-release

echo "Adding Docker's official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "Setting up the Docker stable repository"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

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

echo "getting mapbox key"
inputMapBoxkeyandInsertintosettings

echo "Changing server IP to ALLOWED_HOSTS to everything in cloud_station_web/webgms/settings.py"
sed -i 's/\[\]/\[\*\]/g' ~/cloud_station_web/webgms/settings.py
echo "Turning off debug mode in cloud_station_web/webgms/settings.py"
sed -i 's/DEBUG = True/DEBUG = False/g' ~/cloud_station_web/webgms/settings.py

echo "getting google maps key"
inputGoogleMapsKeyandSaveToEnv

echo "Finished setting up server!"


