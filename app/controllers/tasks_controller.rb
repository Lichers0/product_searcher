# frozen_string_literal: true

class TasksController < ApplicationController
  def new
    self.task = Task.new
  end

  def create
    self.task = Task.new(task_params)
    if task.save
      render :create
    else
      render :new
    end
  end

  private

  attr_accessor :task

  def task_params
    params
      .require(:task)
      .permit(:email, :seller_id, :mws_auth_token, :ship_to_fba, :services_cost, :file)
  end
end
