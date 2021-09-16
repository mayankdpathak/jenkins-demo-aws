import datetime, boto3, os, json
from botocore.exceptions import ClientError

# Set the global variables
globalVars  = {}
globalVars['Owner']                 = "Toyota Motors"
globalVars['Environment']           = "Sub-Prod"
globalVars['tagName']               = "EC2-List-Instances"
globalVars['TopicArn']              = str(os.getenv('TopicArn'))
globalVars['Regions']               = str(os.getenv('Regions'))

def lambda_handler(event, context):

    regions = ['ap-south-1','us-west-2','us-east-1']
    
    msg = (f"Hi Team\n\nBelow is the list of running EC2 Instances with their details:\n\n")
    msg += (f"Name\tInstanceID\tOwnerId\tInstanceType\tState\tRegion\tLaunchTime\n\n")

    for region in regions:
        ec2 = boto3.client('ec2', region_name=region)
        snsClient = boto3.client('sns')

        instances = ec2.describe_instances(
            Filters=[
                {
                    'Name': 'instance-state-name',
                    'Values': ['stopped']
                    }]
                    )
     
        for Reservation in instances['Reservations']:
            for instance in Reservation['Instances']:
                msg += (f"{instance['Tags'][0]['Value']}   {instance['InstanceId']}   {Reservation['OwnerId']}   {instance['InstanceType']}     {instance['State']['Name']}     {instance['Placement']['AvailabilityZone']}     {instance['LaunchTime']} \n")
    
    msg += (f"\n\nBest Regards\nPrivate Cloud Team")
    snsClient.get_topic_attributes(TopicArn=globalVars['TopicArn'])
    snsClient.publish(
        TopicArn = globalVars['TopicArn'],
        Message = msg,
        Subject = f"EC2 Running Instances details"
        )