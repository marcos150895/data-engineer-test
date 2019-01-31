import base64
import json

import boto3
import datetime
import pandas as pd
import hashlib

def dynamo_producer(event, context):

    item = None
    dynamo_db = boto3.resource('dynamodb')
    table = dynamo_db.Table('tweet')

    decoded_record_data = [base64.b64decode(record['kinesis']['data']) for record in event['Records']]
    deserialized_data = [json.loads(decoded_record) for decoded_record in decoded_record_data]

    data_transformed = transform_data(deserialized_data)
    
    with table.batch_writer() as batch_writer:
        for item in data_transformed:
            item['hash_line'] = hash_line(item)
            item['processed_date'] = datetime.datetime.utcnow().isoformat()
            batch_writer.put_item(Item=item)

    print('Number of records: {}'.format(str(len(deserialized_data))))

## function that receive twitter json data and get only user's data and tweet create time and return a list with this data
def transform_data(data):
    df = pd.DataFrame(list(pd.DataFrame(data)['user']))

    # adding prefix in user data
    name_list = []
    for i in list(df.columns):
        name_list.append('user_'+i)
    df.columns = name_list

    # adding tweet created_at
    df['created_at'] = pd.DataFrame(data)['created_at']
	
    #count how many tweets a user did
    aggreg_df = df.groupby(['user_description', 'user_id', 'user_location', 'user_name','user_screen_name', 'user_url'], as_index=False).count()
    aggreg_df = aggreg_df.rename(columns={'created_at': 'tweets_quantity'})

    #getting min and max date posting per user from origin dataframe (raw) between a frame of data
    created_df = df.groupby('user_id', as_index=False).min()[['user_id', 'created_at']].rename(columns={'created_at': 'min_created_at'})
    created_df['max_created_df'] = df.groupby('user_id', as_index=False).max()['created_at']
    aggreg_df = aggreg_df.merge(created_df, on='user_id', how='left') 

    json_list = aggreg_df.to_json(orient='records')
    json_list_load = json.loads(json_list)

    return json_list_load

def hash_line(line):
    hasher = hashlib.sha1()
    hasher.update(str(line).encode('utf-8'))

    return hasher.hexdigest()