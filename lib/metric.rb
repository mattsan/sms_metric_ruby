# frozen_string_literal: true

require 'aws-sdk-cloudwatch'

class Metric
  REGION = 'ap-northeast-1'

  def self.get_metric_data(params)
    client = Aws::CloudWatch::Client.new(region: REGION)

    metric_data_results = []

    loop do
      response = client.get_metric_data(params)
      metric_data_results.concat(response.metric_data_results)

      break unless response.next_token

      params.next_token = response.next_token
    end

    metric_data_results
  end
end

require_relative 'metric/spent_usd'
