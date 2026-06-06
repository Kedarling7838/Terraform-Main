import json
def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    print(f"File uploaded: {key}")
    print(f"Bucket: {bucket}")
    return {
        "statusCode": 200,
        "body": "Success"
    }