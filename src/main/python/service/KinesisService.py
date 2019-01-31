import boto3
from json_encoder import json

kinesis = boto3.client('kinesis')

def insert_data(streamName, data, partitionKey):
    kinesis.put_record(StreamName=streamName, Data=json.dumps(data), PartitionKey=partitionKey)