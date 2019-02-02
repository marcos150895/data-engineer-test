import os
from twython import TwythonStreamer
import KinesisService
from json_encoder import json

class MyStreamer(TwythonStreamer):
    def on_success(self, data):
        self.insert(data)
        print("kinesis inserting this data:" + str(data))
        
    def on_error(self, status_code, data):
        print status_code, data

    def insert(self, data):
        kinesis_stream_name = str(os.environ['kinesis_stream_name'])
        KinesisService.insert_data(kinesis_stream_name, data, "filler")