require 'aws-sdk-dynamodb'

class Storage
  REGION = 'ap-northeast-1'

  def store(time, value)
    # client.put_item(
    pp({
      table_name: table_name,
      item: {
        timestamp: time.strftime('%Y-%m-%d'),
        value: value
      }
    })
  end

  private

  def client
    @client ||= Aws::DynamoDB::Client.new(region: REGION)
  end

  def table_name
    @table_name ||= ENV['TABLE_NAME']
  end
end

