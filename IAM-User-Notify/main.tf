provider "aws" {
  profile = var.profile
  region  = var.region
}

//IAM Role to create for Lambda Function, SNS to read the key of Users

resource "aws_iam_role" "LambdaTestIAM" {
  name = "LambdaIAMRoleTF"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

//Define JSON document for custom IAM Policy

data "aws_iam_policy_document" "IAMNotifyPolDocTF" {
  statement {
    actions = ["logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
    "logs:PutRetentionPolicy"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions   = ["sns:GetTopicAttributes", "sns:List*", "sns:Publish", "sns:GetSubscriptionAttributes", "sns:SetTopicAttributes", "sns:SetSubscriptionAttributes", "sns:GetEndpointAttributes", "sns:SetEndpointAttributes", "sns:ConfirmSubscription"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    actions   = ["iam:List*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

//To create IAM Policy

resource "aws_iam_policy" "LambdaIAMNotifyPol" {
  name        = "LambdaIAMNotifyPol"
  description = "Policy for Lambda Function"
  policy      = data.aws_iam_policy_document.IAMNotifyPolDocTF.json

}

//To attach the Managed IAM Policy to IAM Role created above

resource "aws_iam_role_policy_attachment" "IAMLambdaPolAttachTF" {
  role       = aws_iam_role.LambdaTestIAM.name
  policy_arn = aws_iam_policy.LambdaIAMNotifyPol.arn
}

output "rendered_policy" {
  value = data.aws_iam_policy_document.IAMNotifyPolDocTF.json
}

// To create the SNS Topic which will be using by Lambda Python Code

resource "aws_sns_topic" "LambdaSNSTopic" {
  name = "LambdaSNSTopic"

}

//To create the SNS Topic Subscription for sending email to subscribed users

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.LambdaSNSTopic.arn
  protocol  = "email"
  endpoint  = "mayankdpathak@gmail.com"

}

//To create the Lambda function with Local Code

resource "aws_lambda_function" "LambdaTestTerr" {
  function_name = "LambdaTestTerr"
  description   = "IAM User Key Test Lambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.6"
  timeout       = 300
  memory_size   = 128
  publish       = true
  filename      = "./Lambda-Code.zip"
  role          = aws_iam_role.LambdaTestIAM.arn

  environment {
    variables = {
      region   = var.region
      TopicArn = "${aws_sns_topic.LambdaSNSTopic.arn}"
      key_age  = "0"
    }
  }

}

//To create the Cloudwatch event rule

resource "aws_cloudwatch_event_rule" "CLTerrLambdaEvRule" {
  name                = "CLTerrLambdaEvRule"
  description         = "Trigger for Lambda Call"
  schedule_expression = "rate(2 minutes)"
  is_enabled          = false

}

//To create the Cloudwatch event target

resource "aws_cloudwatch_event_target" "CLTerrEvRuleTarget" {
  rule      = aws_cloudwatch_event_rule.CLTerrLambdaEvRule.name
  target_id = "LambdaTestTerr"
  arn       = aws_lambda_function.LambdaTestTerr.arn

}

//For giving permission and to invoke the lambda function

resource "aws_lambda_permission" "allow_cloudwatch_to_call_Lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.LambdaTestTerr.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.CLTerrLambdaEvRule.arn
}