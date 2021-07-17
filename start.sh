#!/bin/sh

echo Start converting Fronius Sunshine inverter serial output to JSON http endpoint ...

if [ -z `which setserial` ] || [ -z `which screen` ] || [ -z `which stty` ] || [ -z `which python3` ]; then
 if [ ! -z `which opkg` ]; then
  opkg update; opkg install screen python3 setserial
 fi
 echo Check dependencies. Exiting.
 exit 1
fi 

if [ ! -x "./setserbaud.sh" ] ||  [ ! -x "./ser2dec.py" ] || [ ! -x "./ssh_to_stats.sh" ] || [ ! -x "./fifo2json.sh" ]; then
 echo Not all executable scripts in $PWD ... Exiting.
 exit 1
fi

echo Setup serial ports
./setserbaud.sh /dev/ttyS0 3200
./setserbaud.sh /dev/ttyS1 3200

echo Start serial polling ...
screen -dmS serial0 ./ser2dec.py /dev/ttyS0 6 /tmp/fifo.ttyS0
screen -dmS serial1 ./ser2dec.py /dev/ttyS1 6 /tmp/fifo.ttyS1

echo Start ssh to stats server ...
screen -dmS ssh ./ssh_to_stats.sh

sleep 10

echo Start JSON generation ...
screen -dmS convert1 ./fifo2json.sh /tmp/fifo.ttyS0 /tmp/CommonInverterData1.json 1 /tmp/biglog.txt
screen -dmS convert2 ./fifo2json.sh /tmp/fifo.ttyS1 /tmp/CommonInverterData2.json 2 /tmp/biglog.txt

sleep 10

echo Start http server ...
# expects /tmp/CommonInverterData[1/2].json
screen -dmS flask ./flask_start.sh

echo Running.
