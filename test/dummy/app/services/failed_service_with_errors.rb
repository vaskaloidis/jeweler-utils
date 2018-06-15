# This is a simply failed service that returns errors
class FailedServiceWithErrors < Jeweler::Service
  def initialize()
  end

  def call
    errors << 'error 1'
    errors << 'error 2'
    fatals << 'fatal 1'
  end

  private

end