#!/bin/sh

export FLASK_APP=./json_server

while [ 1 ]; do

 cd /root
 
 flask run

 sleep 60
 
done
