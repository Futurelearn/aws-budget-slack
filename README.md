# aws-budget-slack

Lambda function to keep us updated with how much we're spending in AWS.

Idea pinched from [AWS-budget-to-slack](https://github.com/richstokes/AWS-budget-to-slack)
and rewritten in Ruby with added emoji.

## Packaging for Lambda

```
bundle install --path vendor/bundle
zip -r lambda_function.zip lambda_function.rb vendor/
```
