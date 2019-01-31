import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))  +'/lib/')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))  +'/service/')

def lambda_twitter_consumer(event, context):

    from TwitterConsumer import MyStreamer

    try:
        app_key = os.environ['app_key']
        app_secret = os.environ['app_secret']
        oauth_token = os.environ['oauth_token']
        oauth_token_secret = os.environ['oauth_token_secret']
        filter_subject = os.environ['filter_subject']
        kinesis_stream_name = os.environ['kinesis_stream_name']
    except:
        print("Variables not available in application, please send correctly the variables")
    
    stream = MyStreamer(app_key, app_secret, oauth_token, oauth_token_secret)
    stream.statuses.filter(track=str(filter_subject))

def dynamo_producer_from_kinesis(event, context):

    from DynamoProducer import dynamo_producer

    dynamo_producer(event, context)