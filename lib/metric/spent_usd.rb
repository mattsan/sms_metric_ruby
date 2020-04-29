class Metric
  class SpentUSD
    include Enumerable

    Item = Struct.new('Item', :timestamp, :value)

    METRIC_DATA_QUERIES = [
      {
        id: 'spentUSD',
        metric_stat: {
          metric: {
            namespace: 'AWS/SNS',
            metric_name: 'SMSMonthToDateSpentUSD'
          },
          period: 24 * 60 * 60, # seconds per day
          stat: 'Maximum'
        },
      }
    ]

    def initialize
      @spent_usd = []
    end

    def fetch(start_time, end_time)
      metric_data = Metric.get_metric_data(
        metric_data_queries: METRIC_DATA_QUERIES,
        start_time: start_time,
        end_time: end_time
      )

      @spent_usd = metric_data
        .flat_map {|metric| metric.timestamps.zip(metric.values) }
        .map {|timestamp, value| Item.new(timestamp, value) }

      self
    end

    def each
      if block_given?
        @spent_usd.each do |spent_usd|
          yield spent_usd
        end
      else
        to_enum
      end
    end
  end
end
