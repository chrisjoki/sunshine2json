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

. ./server_config

while [ true ]; do
 PID=`ssh -y -p $SSH_PORT -l $SSH_USER $SSH_SERVER ps fax | grep "[p]ython3 $SUNSHINE2JSONPATH/json2influx.py" | awk '{print $1;}'`
 if [ ! -z "$PID" ]; then
  echo Killing old json2influx.py ...
  ssh -y -p $SSH_PORT -l $SSH_USER $SSH_SERVER kill $PID
  sleep 3
 fi
 echo Starting json2influx ...
 ssh -K 10 -I 60 -y -p $SSH_PORT -l $SSH_USER -R $WWW_PORT:127.0.0.1:$WWW_PORT $SSH_SERVER python3 $SUNSHINE2JSONPATH/json2influx.py
 echo Recycling ...
 sleep 3
done

