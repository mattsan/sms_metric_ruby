require_relative 'lib/handler'

def store(event:, context:)
  Handler.new(event).store
end
