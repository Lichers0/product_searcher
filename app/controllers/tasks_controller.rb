# frozen_string_literal: true

class TasksController < ApplicationController
  def new
    self.task = Task.new
  end

  def create
    self.task = Task.new(task_params)
    return render :new if api_errors?

    render task.save ? :create : :new
  end

  private

  attr_accessor :task

  def task_params
    params.require(:task).permit(:email, :seller_id, :mws_auth_token, :ship_to_fba, :services_cost, :file)
  end

  def api_errors?
    return false unless ApiChecker.call(task_params.to_h)

    task.errors.add(:wrong_keys, "amazon keys errors")
    true
  end
end
