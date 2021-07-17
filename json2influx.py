from FroniusToInflux import FroniusToInflux
from influxdb import InfluxDBClient
from astral import Location

import pytz


client = InfluxDBClient(host='localhost', port=8086, username='grafana', password='grafana', ssl=False)
client.switch_database('grafana')
location = Location(('Munich', 'Europe', 48.169498646, 11.635465622, 'Europe/Berlin', 520))
tz = pytz.timezone('Europe/Berlin')
endpoints = [
#    'http://127.0.0.1:5000/3PInverterData.json',
#    'http://127.0.0.1:5000/CommonInverterData.json',
#    'http://127.0.0.1:5000/MinMaxInverterData.json'
    'http://127.0.0.1:5000/CommonInverterData1.json',
    'http://127.0.0.1:5000/CommonInverterData2.json'
]

z = FroniusToInflux(client, location, endpoints, tz)
z.IGNORE_SUN_DOWN = True
z.run()
