# TODO: Add RDocs
# TODO: Specify the Rescue From Catching ALL Errors. Only Specific ones, then handle them
# TODO: Implement various tools from ActiveModel Callbacks like serialization etc... http://www.thegreatcodeadventure.com/smarter-rails-services-with-active-record-modules/
module Jeweler

  class Service
    attr_accessor :result, :errors, :fatals, :result, :result_message

    def self.call(*args)

      new(*args).tap do |service|
        service.instance_variable_set('@errors', Array.new)
        service.instance_variable_set('@fatals', Array.new)
        service.instance_variable_set('@result_message', '')

        service.instance_variable_set("@result", service.call)

        tapped_errors = service.instance_variable_get('@errors')
        tapped_fatals = service.instance_variable_get('@fatals')

        first_fatal = true
        tapped_fatals.each do |fatal|
          Rails.logger.error 'ServiceObject Fatal Error: ' + fatal
          if first_fatal
            tapped_errors << 'There was an error. Contact Support.'
            first_fatal = false
          end
        end

        service.instance_variable_set('@errors', tapped_errors)

      end
    end

    def call
      raise NotImplementedError
    end

  end
end