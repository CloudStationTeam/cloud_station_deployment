#!/bin/bash
rm -r ENV

rm -rf cloud_station_deployment 

rm -rf cloud_station_web

#sudo reboot

git clone https://github.com/CloudStationTeam/cloud_station_deployment.git
sleep 3

# Update requirements.txt.
# Edit setup_server.sh if your cloud_station_web repo is a different one.
bash ~/cloud_station_deployment/setup_server.sh --tag=v3.0 

# Refer to 
# https://cloud-station-docs.readthedocs.io/en/latest/deployment.html#step-by-step-deployment-guide 
# to edit the files.

#ps aux | grep nginx | grep -v grep #find nginx user
#sudo nginx -T | grep "cache" #check for cache files

sudo usermod -a -G ubuntu www-data #add nginx user to the ubuntu group 
# optional 
sudo chgrp -R ubuntu * #change file owners to ubuntu group 
sudo chmod -R g+r * #change file permissions of file owners 

bash ~/cloud_station_deployment/configure_web_server.sh 

# Edit reload_server.sh if your cloud_station_web repo is a different one.
bash ~/cloud_station_deployment/reload_server.sh 

echo "Print Logs"
journalctl -u daphne.service | tail #print logs 


source ./ENV/bin/activate  # Activate the Env 
pip freeze  # List installed packages
deactivate
