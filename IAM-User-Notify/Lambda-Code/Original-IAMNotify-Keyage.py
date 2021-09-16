# List IAM users having 90 days older Access keys

import datetime, boto3, os, json
from botocore.exceptions import ClientError

# Set the global variables
globalVars  = {}
globalVars['Owner']                 = "Mayank"
globalVars['Environment']           = "Test"
globalVars['REGION_NAME']           = str(os.getenv('region'))
globalVars['tagName']               = "Lambda-IAM-Users-AccessKey-Notify"
globalVars['key_age']               = str(os.getenv('key_age'))
globalVars['TopicArn']        		= str(os.getenv('TopicArn'))

def get_usr_old_keys( keyAge ):
    client = boto3.client('iam',region_name = globalVars['REGION_NAME'])
    snsClient = boto3.client('sns',region_name = globalVars['REGION_NAME'])
    usersList=client.list_users()
   
    timeLimit=datetime.datetime.now() - datetime.timedelta( days = int(keyAge) )
    usrsWithOldKeys = {'Users':[],'Description':'List of users with Key Age greater than (>=) {} days'.format(keyAge),'KeyAgeCutOff':keyAge}

    # Iterate through list of users and compare with `key_age` to flag old key owners
    for k in usersList['Users']:
        accessKeys=client.list_access_keys(UserName=k['UserName'])
    
        # Iterate for all users
        for key in accessKeys['AccessKeyMetadata']:
            if key['CreateDate'].date() <= timeLimit.date():
                usrsWithOldKeys['Users'].append({ 'UserName': k['UserName'], 'KeyAgeInDays': (datetime.date.today() - key['CreateDate'].date()).days })
				if usrsWithOldKeys < key_age
				try:
				snsClient.get_topic_attributes( TopicArn= globalVars['TopicArn'] )
				snsClient.publish(TopicArn = globalVars['TopicArn'], Message = json.dumps(usrsWithOldKeys, indent=4) )
				usrsWithOldKeys['Emailed']="Yes"
				
				except ClientError as e:
				usrsWithOldKeys['Emailed']="No - TopicArn is Incorrect"

    return usrsWithOldKeys

#        # If no users found with older keys, add message in response
#        if not usrsWithOldKeys['Users']:
#            usrsWithOldKeys['OldKeyCount'] = 'Found 0 Keys that are older than {} days'.format(keyAge)
#        else:
#            usrsWithOldKeys['OldKeyCount'] = 'Found {0} Keys that are older than {1} days'.format(len(usrsWithOldKeys['Users']), keyAge)


def lambda_handler(event, context):   
    # Set the default cutoff if env variable is not set
    globalVars['key_age'] = int(os.getenv('key_age',90))
    globalVars['TopicArn']=str(os.getenv('TopicArn'))
	globalVars['REGION_NAME']=str(os.getenv('region'))

    return get_usr_old_keys( globalVars['key_age'] )

