class Metric
  class SpentUSD
    include Enumerable

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
        .flat_map {|metric| metric.timestamps.zip(metric.values) }
        .map {|timestamp, value| Item.new(timestamp, value) }

      self
    end

    def each
      if block_given?
        @spent_usd.each do |item|
          yield item
        end
      else
        to_enum
      end
    end

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
          },
        }
      ]
    end
  end
end
