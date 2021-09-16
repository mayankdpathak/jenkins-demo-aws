import datetime, boto3, os, json
from botocore.exceptions import ClientError

# Set the global variables
globalVars  = {}
globalVars['Owner']                 = "Mayank"
globalVars['Environment']           = "Test"
globalVars['REGION_NAME']           = str(os.getenv('region'))
globalVars['tagName']               = "Lambda-IAM-Users-AccessKey-Notify"
globalVars['key_age']               = str(os.getenv('key_age'))
globalVars['TopicArn']              = str(os.getenv('TopicArn'))

def get_usr_old_keys( keyAge ):
    client = boto3.client('iam')
    snsClient = boto3.client('sns')
    usersList=client.list_users()
    
    timeLimit=datetime.datetime.now() - datetime.timedelta( days = int(keyAge) )
    usrsWithOldKeys = {'Description':'Below is the List of users with Key Age','Users':[]}
    
    

    # Iterate through list of users and compare with `key_age` to flag old key owners
    for k in usersList['Users']:
        accessKeys=client.list_access_keys(UserName=k['UserName'])
    
        # Iterate for all users
        for key in accessKeys['AccessKeyMetadata']:
            if key['CreateDate'].date() <= timeLimit.date():
                usrsWithOldKeys['Users'].append({ 'UserName': k['UserName'], 'KeyAgeInDays': (datetime.date.today() - key['CreateDate'].date()).days })
                
                msg = "Hi Team\n\nBelow is the list of Secret Key Age of Users\n\n"
                for user in usrsWithOldKeys['Users']:
                    msg += (f"UserName : {user['UserName']}\nKeyAgeInDays:{user['KeyAgeInDays']}\n\n")
                msg += "\n\nRegards\n\nPrivate Cloud Team\n\n"

        # If no users found with older keys, add message in response
        if not usrsWithOldKeys['Users']:
            usrsWithOldKeys['OldKeyCount'] = 'Found 0 Keys that are older than {} days'.format(keyAge)
        else:
            usrsWithOldKeys['OldKeyCount'] = 'Found {} Keys that are older than {} days'.format(len(usrsWithOldKeys['Users']), keyAge)
            try:
                snsClient.get_topic_attributes( TopicArn= globalVars['TopicArn'] )
                snsClient.publish(
                    TopicArn = globalVars['TopicArn'],
                    Message = msg,
                    Subject = f"Warning: Security Access Keys Expiring in {globalVars['key_age']} days"
                    )
                usrsWithOldKeys['EmailSent']="Yes"
            except ClientError as e:
                usrsWithOldKeys['EmailSent']="No - TopicArn is Incorrect"
        return usrsWithOldKeys


def lambda_handler(event, context):   
    # Set the default cutoff if env variable is not set
    globalVars['key_age'] = int(os.getenv('key_age'))
    globalVars['TopicArn']=str(os.getenv('TopicArn'))
    globalVars['REGION_NAME']=str(os.getenv('region'))

    return get_usr_old_keys( globalVars['key_age'] )