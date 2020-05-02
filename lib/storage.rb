# frozen_string_literal: true

require 'aws-sdk-dynamodb'

class Storage
  REGION = ENV['REGION']

  def store(time, value)
    client.put_item(
      table_name: table_name,
      item: {
        timestamp: time.strftime('%Y-%m-%d'),
        value: value
      }
    )
  end

  private

  def client
    @client ||= Aws::DynamoDB::Client.new(region: REGION, stub_responses: true)
  end

  def table_name
    @table_name ||= ENV['TABLE_NAME']
  end
end
