module Jeweler
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

        begin
          @tapped_result = service.call
        rescue StandardError => e
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