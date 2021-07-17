#!/bin/sh

## Set baud rate of serial tty

if [ "$#" -ne 2 ]; then
 echo Usage: setserbaud serial baud
 exit 1
fi

if [ ! -c "$1" ]; then
 echo Please specify valid serial port
 exit 1
fi

if [ -z `which setserial` ]; then
 echo Please install setserial.
 exit 1
fi

if [ -z `which stty` ]; then
 echo Please install stty.
 exit 1
fi

BAUDBASE=`setserial -a $1 | tr "," "\n" | grep Baud_base: |tr "Baud_base: " " "` 

echo Base baud rate is $BAUDBASE

if [ "$2" -lt 300 ]; then
 echo baud too low.
 exit 1
elif [ "$2" -gt $BAUDBASE ]; then
 echo baud to high. $BAUDBASE is max
 exit 1
else
 TARGETBAUD=$2
fi

DIVISOR=$((BAUDBASE/TARGETBAUD))
CALCULATEDBAUD=$((BAUDBASE/DIVISOR))

if [ $CALCULATEDBAUD -ne $TARGETBAUD ]; then
 echo Invalid target baudrate.
 exit 1
fi

setserial -a $1 spd_cust

echo Setting divisor to $DIVISOR

setserial -a $1 divisor $DIVISOR

if [ ! $? ]; then
 echo Error setting divisor.
 exit 1
fi

echo Setting baud rate of $1 to $TARGETBAUD

stty -F $1 38400 crtscts

stty -F $1 -icanon

setserial -a $1 spd_cust

