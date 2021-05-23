# frozen_string_literal: true

class SearchTaskJob < ApplicationJob
  queue_as :default

  def perform(task)
    SearchTask.new(task).create
  end
end
