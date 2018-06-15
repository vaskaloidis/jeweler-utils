require 'test_helper'

class Jeweler::ServiceTest < ActiveSupport::TestCase
  test "failed service object returns errors" do
    class FailedServiceWithErrors < Jeweler::Service
      def call
        errors << 'error 1'
        errors << 'error 2'
        fatals << 'fatal 1'
      end
    end
    so = FailedServiceWithErrors.call
    assert_equal 3, so.errors.count
    assert_includes so.errors, 'error 1'
    assert_includes so.errors, 'error 2'
    assert_includes so.errors, 'fatal 1'
    assert_equal so.success, true
  end
  test "failed service" do
    class FailedService < Jeweler::Service
      def call
        @success = false
      end
    end
    so = FailedService.call
    refute so.success
  end

  test "successful service object returns errors" do
    class SuccessfulServiceWithErrors < Jeweler::Service
      def call
        errors << 'error 1'
        errors << 'error 2'
        fatals << 'fatal 1'
        @success = true
      end
    end
    so = SuccessfulServiceWithErrors.call
    assert_equal 3, so.errors.count
    assert so.success
  end

  test "unsuccesful service" do
    class SuccessServiceObject < Jeweler::Service
      def call; end
    end
    so = SuccessServiceObject.call
    assert so.success
  end

  test "the class passed-in is modified and returned as result" do
    task = Task.new(hours: 5.0)
    so = ModifiesTaskService.call(task)
    assert_equal 1.0, so.result.hours
  end

  test "does not modify a task passed into the SO" do
    task = Task.new(hours: 5.0)
    so = EmptyServiceObject.call(task)
    assert_equal task, so.result
  end

end
