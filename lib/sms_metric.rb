# frozen_string_literal: true

require 'time'
require 'aws-sdk-dynamodb'

require_relative 'storage'
require_relative 'metric'

class String
  def date_string_to_time(timezone)
    Time.parse("#{self}T00:00:00#{timezone}")
  end
end

class Time
  def self.today(timezone)
    current = now.getlocal(timezone)
    new(current.year, current.month, current.day, 0, 0, 0, current.strftime('%:z'))
  end
end

class SmsMetric
  SECONDS_PER_DAY = 24 * 60 * 60
  TIMEZONE = '+09:00'
  TABLE_NAME = ENV['TABLE_NAME']

  def self.store_spent_usd(event:, context:)
    end_date = event['end_date']&.date_string_to_time(TIMEZONE) || Time.today(TIMEZONE)
    start_date = event['start_date']&.date_string_to_time(TIMEZONE) || (end_date - SECONDS_PER_DAY)

    storage = Storage.new(TABLE_NAME)
    spent_usd = Metric::SpentUSD.new

    spent_usd.fetch(start_date, end_date, SECONDS_PER_DAY).each do |item|
      storage.store(item.timestamp.getlocal(TIMEZONE), Metric::SpentUSD::TYPE, item.value)
    end
  end
end
