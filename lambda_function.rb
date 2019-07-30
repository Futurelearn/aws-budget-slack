require 'aws-sdk-budgets'
require 'aws-sdk-core'
require 'slack-ruby-client'

def call(event: nil, context: nil)
  if slack_api_token.nil?
    abort("Must set SLACK_API_TOKEN environment variable!")
  end

  send_slack_message
end

private

def budget_client
  Aws::Budgets::Client.new.describe_budget(
    account_id: account_id,
    budget_name: budget_name
  ).budget
end

def actual_spend
  budget_client.calculated_spend.actual_spend.amount.to_i.ceil
end

def forecast_spend
  budget_client.calculated_spend.forecasted_spend.amount.to_i.ceil
end

def set_budget
  budget_client.budget_limit.amount.to_i.ceil
end

def slack_message_content
  <<~TEXT
    :moneybag: *AWS Budget Report* (for #{Date.today.strftime("%B")}) :money_with_wings:

    The monthly budget is: *$#{set_budget}* :face_with_monocle:

    The actual spend so far this month is: *$#{actual_spend}* :dollar:

    The forecasted spend is: *$#{forecast_spend}* :sweat_smile:

    #{":sadwich:" if actual_spend > set_budget}
    #{":monopoly:" if forecast_spend < set_budget}
  TEXT
end

def send_slack_message
  slack = Slack::Web::Client.new(token: slack_api_token)

  slack.chat_postMessage(channel: slack_channel, text: slack_message_content, as_user: true)
end

def slack_api_token
  ENV['SLACK_API_TOKEN']
end

def slack_channel
  ENV['SLACK_CHANNEL'] || '#ops'
end

def account_id
  Aws::STS::Client.new.get_caller_identity.account
end

def budget_name
  ENV['BUDGET_NAME'] || 'Monthly Total AWS Budget'
end
