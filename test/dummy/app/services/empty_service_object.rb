# frozen_string_literal: true

# Does nothing to a task passed into the Service Object
class EmptyServiceObject < Jeweler::Service
  def initialize(task)
    @task = task
  end
  def call
    task
  end
  private
  attr_reader :task
end
