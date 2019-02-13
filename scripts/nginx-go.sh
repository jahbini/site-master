#! /bin/bash
#
sudo cp ~/site-master/sites-enabled-default /etc/nginx/sites-available/default
sudo cp ~/site-master/sites-enabled-default /etc/nginx/sites-enabled/default
sudo cp ~/site-master/nginx.conf /etc/nginx/
sudo nginx -s reload
