#!/bin/bash
echo "Django migration"
source ~/ENV/bin/activate
python3 ~/cloud_station_web/manage.py makemigrations
python3 ~/cloud_station_web/manage.py migrate

echo "Collecting staticfiles"
if [ ! -d "~/cloud_station_web/static" ]; then
    mkdir ~/cloud_station_web/static
fi
python3 ~/cloud_station_web/manage.py collectstatic --no-input

echo "Configuring NGINX and Daphne"
sudo cp ~/cloud_station_deployment/nginx.conf /etc/nginx
if [ ! -d "~/logs" ]; then
    mkdir ~/logs
fi
sudo service nginx restart
sudo cp ~/cloud_station_deployment/daphne.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start daphne.service

echo "Configuring django-background-tasks"
sudo cp ~/cloud_station_deployment/backgroundtasks.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start backgroundtasks.service

echo "Running docker (redis)"
sudo systemctl start docker
sudo systemctl enable docker
sudo docker run -p 6379:6379 -d redis:2.8