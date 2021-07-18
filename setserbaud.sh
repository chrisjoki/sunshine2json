#!/bin/sh


# MIT License
#
# Copyright (c) 2021 chrisjoki
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:#
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Set baud rate of serial tty
# special thanks to WolliK

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

BAUDBASE=`setserial -a $1 | tr "," "\n" | grep Baud_base: | sed 's/\s//g' | cut -d ':' -f2` 

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

stty -F $1 cs8 cstopb crtscts -parenb -icanon

echo Setting divisor to $DIVISOR

setserial -a $1 divisor $DIVISOR

if [ ! "$?" ]; then
 echo Error setting divisor.
 exit 1
fi

echo Setting baud rate of $1 to $TARGETBAUD

setserial -a $1 spd_cust

stty -F $1 38400
