require_relative 'lib/sms_metric'

def store(event:, context:)
  SmsMetric.new(event).store
end
