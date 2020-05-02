require 'time'
require 'aws-sdk-dynamodb'

require_relative 'storage'
require_relative 'metric'

class String
  def date_string_to_time
    Time.parse("#{self}T00:00:00#{SmsMetric::TIMEZONE}")
  end
end

class Time
  def self.today
    current = now.getlocal(SmsMetric::TIMEZONE)
    new(current.year, current.month, current.day, 0, 0, 0, current.strftime('%:z'))
  end
end

class SmsMetric
  SECONDS_PER_DAY = 24 * 60 * 60
  TIMEZONE = '+09:00'

  def self.store_spent_usd(event:, context:)
    end_date = event['end_date']&.date_string_to_time || Time.today
    start_date = event['start_date']&.date_string_to_time || (end_date - SECONDS_PER_DAY)

    storage = Storage.new
    spent_usd = Metric::SpentUSD.new

    spent_usd.fetch(start_date, end_date).each do |item|
      storage.store(item.timestamp.getlocal(TIMEZONE), item.value)
    end
  end
end
