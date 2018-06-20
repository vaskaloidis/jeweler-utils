# TODO: Add RDocs
# TODO: Specify the Rescue From Catching ALL Errors. Only Specific ones, then handle them
# TODO: Implement various tools from ActiveModel Callbacks like serialization etc... http://www.thegreatcodeadventure.com/smarter-rails-services-with-active-record-modules/
module Jeweler

  # Service Object Class that all Jeweler Service Objcts will inherit from, allowing them
  # to report errors, fatal-errors, success? and a success_message. This class also logs
  # any errors that happen in the `call` of the Service Object, logging the tennant-id
  # (project ID), the current-user ID, the action and controllers, and IP Address
  class Service
    attr_accessor :result, :errors, :fatals, :success, :success_message

    def self.call(*args)
      # When Success is not set: Do we fail service objects just because they have errors?
      @fail_service_object_if_has_errors = false

      new(*args).tap do |service|
        service.instance_variable_set(
            '@errors',
            []
        )
        service.instance_variable_set(
            '@fatals',
            []
        )

        @tapped_result = service.call
        begin
        rescue StandardError => e
          # @TODO: Use the new logger for multi-tenant debugging
          # @TODO: Rescue from specific Errors, not this one
          Rails.logger.fatal('ServiceObject Exception: ' + e.message)
          service.instance_variable_set(
              '@success',
              false
          )
        end

        service.instance_variable_set(
            '@result',
            @tapped_result
        )
        tapped_errors = service.instance_variable_get('@errors')
        tapped_fatals = service.instance_variable_get('@fatals')

        tapped_errors.each do |error|
          Rails.logger.warn 'ServiceObject Warning: ' + error
        end

        tapped_fatals.each do |fatal|
          Rails.logger.error 'ServiceObject Error: ' + fatal
          tapped_errors << fatal
        end

        if service.instance_variable_get('@success').nil?
          if @fail_service_object_if_has_errors
            if tapped_errors.empty?
              service.instance_variable_set('@success', true)
            else
              service.instance_variable_set('@success', false)
            end
          else
            service.instance_variable_set('@success', true)
          end
        end

        service.instance_variable_set(
            '@errors',
            tapped_errors
        )

      end
    end

    def call
      raise NotImplementedError
    end

  end
end