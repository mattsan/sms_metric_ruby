require 'time'
require 'aws-sdk-dynamodb'

require_relative 'storage'
require_relative 'metric'

class SmsMetric
  SECONDS_PER_DAY = 24 * 60 * 60
  TIMEZONE = '+09:00'

  def initialize(start_date, end_date)
    @end_date = date_string_to_time(end_date) || today
    @start_date = date_string_to_time(start_date) || (@end_date - SECONDS_PER_DAY)
  end

  def store
    storage = Storage.new
    spent_usd = Metric::SpentUSD.new

    spent_usd.fetch(@start_date, @end_date).each do |item|
      storage.store(item.timestamp.getlocal(TIMEZONE), item.value)
    end
  end

  private

  def today
    now = Time.now.getlocal(TIMEZONE)
    Time.new(now.year, now.month, now.day, 0, 0, 0, now.strftime('%:z'))
  end

  def date_string_to_time(date_string)
    if date_string
      Time.parse("#{date_string}T00:00:00#{TIMEZONE}")
    end
  end
end

def store(event:, context:)
  SmsMetric.new(event['start_date'], event['end_date']).store
end
