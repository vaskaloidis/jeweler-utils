# frozen_string_literal: true

# Modifies a task and returns the modified version as a result
class ModifiesTaskService < Jeweler::Service
  def initialize(task)
    @task = task
  end

  def call
    task.hours = 1.0
    task
  end

  private

  attr_reader :task
end
