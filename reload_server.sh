#!/bin/bash
echo "Updating src code"
cd ~/cloud_station_web
git pull
echo "Django migration"
source ~/ENV/bin/activate
python3 ~/cloud_station_web/manage.py makemigrations
python3 ~/cloud_station_web/manage.py migrate
python3 ~/cloud_station_web/manage.py migrate --run-syncdb

echo "Collecting staticfiles"
python3 ~/cloud_station_web/manage.py collectstatic --no-input

echo "Reloading NGINX and Daphne"
sudo service nginx reload
sudo systemctl daemon-reload
sudo systemctl restart daphne.service

echo "Run django_background_tasks"
sudo service backgroundtasks restart
