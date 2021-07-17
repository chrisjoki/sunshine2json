#!/bin/sh

. ./server_config

while [ true ]; do
 ssh -y -p $SSH_PORT $SSH_SERVER -l $SSH_USER -R $WWW_PORT:127.0.0.1:$WWW_PORT
 sleep 60
done

