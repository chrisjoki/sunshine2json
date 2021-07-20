# sunshine2json
Publish energy data of Fronius Sunhine inverters gathered directly from serial port of inverter to http/json endpoint on remote server for use with Influx/Grafana

# Remarks
Developed on OpenWRT / Futro S550 with two serial ports connected via nullmodem cables to two Fronius Sunshine Maxi inverters

# Install
git clone https://github.com/chrisjoki/sunshine2json # Both, on system connected to inverter(s) and Influx/Grafana server

cd sunshine2json

cp server_config.template server_config

vi server_config

Import *.json to Grafana

Generate dropbear ssh key on OpenWRT device: dropbearkey -t rsa -f ~./ssh/id_dropbear

Put pubkey on Influx machine to enable scripted login

# Dependencies
opkg update; okpg install python3 screen setserial pip3 coreutils-stty tio

pip3 install Flask pytz 

# Run
cd sunshine2json

./start.sh

# Debugging
screen -r

tail -f /tmp/biglog.txt

cat /tmp/CommonInverterData[1,2].json

# Todo
Influx/Grafana part
