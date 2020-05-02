require_relative 'lib/sms_metric'

class Handler
  def self.store(event:, context:)
    SmsMetric.new(event).store
  end
end
