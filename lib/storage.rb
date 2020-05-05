# frozen_string_literal: true

require 'aws-sdk-dynamodb'

class Storage
  REGION = ENV['REGION']

  def initialize(table_name)
    @table_name = table_name
  end

  def store(time, type, value)
    client.put_item(
      table_name: @table_name,
      item: {
        timestamp: time.strftime('%Y-%m-%d'),
        type: type,
        value: value
      }
    )
  end

  private

  def client
    @client ||= Aws::DynamoDB::Client.new(region: REGION)
  end
end
