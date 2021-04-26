# frozen_string_literal: true

class TasksController < ApplicationController
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      ImportPriceJob.perform_later(@task)
      render :create
    else
      render :new
    end
  end

  private

  def task_params
    params
      .require(:task)
      .permit(:email, :seller_id, :mws_auth_token, :ship_to_fba, :services_cost, :file)
  end
end
