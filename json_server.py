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
    except FileExistsError:
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
    except FileExistsError:
        abort(404)
    except
        raise                   
