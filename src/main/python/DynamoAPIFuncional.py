import boto3
import json

dynamo = boto3.resource('dynamodb')
dynamo = dynamo.Table('tweet')

def respond(err, res=None):
    return {
        'statusCode': '400' if err else '200',
        'body': err.message if err else json.dumps(res),
        'headers': {
            'Content-Type': 'application/json',
        },
    }

def lambda_handler(event, context):

    operations = {
        'GET': lambda dynamo, x: dynamo.scan(),
        'POST': lambda dynamo, x: dynamo.put_item(),
        'PUT': lambda dynamo, x: dynamo.update_item(**x),
    }
    
    operation = event['httpMethod']
    if operation in operations: 
        if operation == 'GET':
            payload = 'tweets'
        else:
            payload = json.loads(event['body'])
        return respond(None, operations[operation](dynamo, payload))
    else:
        return respond(ValueError('Unsupported method "{}"'.format(operation)))