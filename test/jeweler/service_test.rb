require 'test_helper'

class Jeweler::ServiceTest < ActiveSupport::TestCase
  setup do
    @generic_error = 'There was an error. Contact Support.'
  end
  test "failed service object returns errors" do
    class ServiceObject1 < Jeweler::Service
      def call
        errors << 'error 1'
        errors << 'error 2'
        fatals << 'fatal 1'
      end
    end
    so = ServiceObject1.call
    assert_equal 3, so.errors.count
    assert_includes so.errors, 'error 1'
    assert_includes so.errors, 'error 2'
    assert_includes so.errors, @generic_error
    assert_equal '', so.result_message
  end

  test "successful service object returns errors" do
    class ServiceObject2 < Jeweler::Service
      def call
        errors << 'error 1'
        errors << 'error 2'
        @result_message = 'great!'
      end
    end
    so = ServiceObject2.call
    assert_equal 2, so.errors.count
    assert_includes so.errors, 'error 1'
    assert_includes so.errors, 'error 2'
    assert_equal 'great!', so.result_message
  end

  test 'single fatal' do
    class ServiceObject3 < Jeweler::Service
      def call
        fatals << 'fatal 1'
      end
    end
    so = ServiceObject3.call
    assert_equal 1, so.errors.count
    assert_equal '', so.result_message
    assert_includes so.errors, @generic_error
  end

  test 'multiple fatals' do
    class ServiceObject3_1 < Jeweler::Service
      def call
        fatals << 'fatal 1'
        fatals << 'fatal 2'
      end
    end
    so = ServiceObject3_1.call
    assert_equal 1, so.errors.count
    assert_equal '', so.result_message
    assert_includes so.errors, 'There was an error. Contact Support.'
  end

  test "the class passed-in is modified and returned as result" do
    class ServiceObject4 < Jeweler::Service
      def initialize(task)
        @task = task
      end
      def call
        task.hours = 1.0
        @result_message = 'all good!'
        task
      end
      private
      attr_reader :task
    end
    task = Task.new(hours: 5.0)
    so = ServiceObject4.call(task)
    assert_equal 1.0, so.result.hours
    assert_equal 'all good!', so.result_message
  end

  test "does not modify a task passed into the SO" do
    class ServiceObject5 < Jeweler::Service
      def initialize(task)
        @task = task
      end
      def call
        task
      end
      private
      attr_reader :task
    end
    task = Task.new(hours: 5.0)
    so = ServiceObject5.call(task)
    assert_equal task, so.result
    assert_equal '', so.result_message
  end

  test "variables in the helpers" do
    class ServiceObject6 < Jeweler::Service
      def initialize(task)
        @task = task
      end
      def call
        helper1
        helper2
        task
      end
      private
      def helper1
        errors << 'error 1'
      end
      def helper2
        errors << 'error 2'
        @result_message = 'result good'
      end
      attr_reader :task
    end
    task = Task.new(hours: 5.0)
    so = ServiceObject6.call(task)
    assert_equal task, so.result
    assert_equal 2, so.errors.count
    assert_equal 'result good', so.result_message
    assert_includes so.errors, 'error 1'
    assert_includes so.errors, 'error 2'
  end

  test "fatals in the helpers" do
    class ServiceObject7 < Jeweler::Service
      def initialize(task)
        @task = task
      end
      def call
        helper2
        task
      end
      private
      def helper2
        fatals << 'fatal 1'
      end
      attr_reader :task
    end
    task = Task.new(hours: 5.0)
    so = ServiceObject7.call(task)
    assert_equal task, so.result
    assert_equal '', so.result_message
    assert_equal 1, so.errors.count
    assert_includes so.errors, @generic_error
  end

end
