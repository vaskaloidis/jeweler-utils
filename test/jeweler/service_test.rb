require 'test_helper'

class Jeweler::ServiceTest < ActiveSupport::TestCase
  test "errored service object returns errors" do
    so = FailedServiceWithErrors.call
    refute so.errors.empty?
  end

  test "the class passed-in is modified and returned as result" do
    task = Task.new(hours: 5.0)
    so = ModifiesTaskService.call(task)
    assert_equal 1.0, so.result.hours
  end

end
