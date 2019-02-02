import boto3
import json

dynamo = boto3.resource('dynamodb')
dynamo = dynamo.Table('tweet')

def dynamo_api(event, context):
    operations = {
        'GET': lambda dynamo, x: dynamo.scan(),
        'POST': lambda dynamo, x: dynamo.put_item(**x),
        'PUT': lambda dynamo, x: dynamo.update_item(**x),
    }
    
    operation = 'GET'
    print(operation)
    if operation in operations:
        if operation == 'GET':
            payload = 'tweets'
        else:
            payload = event['body']
        print(respond(None, operations[operation](dynamo, payload)))
        return respond(None, operations[operation](dynamo, payload))
    else:
        return respond(ValueError('Unsupported method "{}"'.format(operation)))

def respond(err, res=None):
    print(err)
    return {
        'statusCode': '400' if err else '200',
        'body': err.message if err else json.dumps(res),
        'headers': {
            'Content-Type': 'application/json',
        },
    }


