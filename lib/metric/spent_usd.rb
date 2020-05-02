# frozen_string_literal: true

require 'forwardable'

class Metric
  class SpentUSD
    include Enumerable
    extend Forwardable

    Item = Struct.new('Item', :timestamp, :value)

    def initialize
      @spent_usd = []
    end

    def fetch(start_time, end_time, period)
      metric_data = Metric.get_metric_data(
        metric_data_queries: metric_data_queries(period),
        start_time: start_time,
        end_time: end_time
      )

      @spent_usd = metric_data
                   .flat_map { |metric| metric.timestamps.zip(metric.values) }
                   .map { |timestamp, value| Item.new(timestamp, value) }

      self
    end

    def_delegators :@spent_usd, :each

    private

    def metric_data_queries(period)
      [
        {
          id: 'spentUSD',
          metric_stat: {
            metric: {
              namespace: 'AWS/SNS',
              metric_name: 'SMSMonthToDateSpentUSD'
            },
            period: period,
            stat: 'Maximum'
          }
        }
      ]
    end
  end
end
