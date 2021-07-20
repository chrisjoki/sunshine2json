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

from flask import Flask, request
import random
import json
import datetime
import pytz

app = Flask(__name__)

#with open('CommonInverterData.json', 'r') as f:
#    common_inverter_data = [json.loads(r) for r in f.readlines()]


@app.route('/CommonInverterData1.json')
def common_inverter_data_endpoint1() -> str:
    now = datetime.datetime.now(tz=pytz.timezone('Europe/Berlin')).isoformat('T')
    try:
        with open('/tmp/CommonInverterData1.json', 'r') as f:
            common_inverter_data = [json.loads(r) for r in f.readlines()]
        json_response = random.choice(common_inverter_data)
        json_response['Head']['Timestamp'] = now
        return json_response
    except FileNotFoundError:
        abort(404)
    except
        raise                   

@app.route('/CommonInverterData2.json')
def common_inverter_data_endpoint2() -> str:
    now = datetime.datetime.now(tz=pytz.timezone('Europe/Berlin')).isoformat('T')
    try:
        with open('/tmp/CommonInverterData2.json', 'r') as f:
            common_inverter_data = [json.loads(r) for r in f.readlines()]
        json_response = random.choice(common_inverter_data)
        json_response['Head']['Timestamp'] = now
        return json_response
    except FileNotFoundError:
        abort(404)
    except
        raise                   
