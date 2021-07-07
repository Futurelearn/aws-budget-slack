# aws-budget-slack

Lambda function to keep us updated with how much we're spending in AWS.

Idea pinched from [AWS-budget-to-slack](https://github.com/richstokes/AWS-budget-to-slack)
and rewritten in Ruby with added emoji.

## Packaging for Lambda

```
rm -rf vendor/
bundle config set path 'vendor/bundle'
bundle install
zip -r lambda_function.zip lambda_function.rb vendor/
```

## Updating this function

You will need to manually upload the zip file via the AWS management console. 
Do not commit the zip file in this repo. 

If we're upgrading the Ruby version, you can run: 

```
aws lambda update-function-configuration --function-name aws-budget-slack --runtime ruby2.7
```

This can't be done via the UI. 

## Authenticating with the Slack API

We use the `aws_accountant` user to post budget updates. We post using an API 
token which can be generated here:

https://futurelearn.slack.com/services/BLYSSAL78

You will need to update `SLACK_API_TOKEN` in the lambda config settings. This can 
be done via the UI. 

You might have to re-add the slack user to the channel where you want to post. 
