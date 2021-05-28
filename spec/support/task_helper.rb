# frozen_string_literal: true

module TaskHelper
  def create_task
    task = build(:task, file: fixture_file_upload("correct.csv"))
    allow(task).to receive(:amazon_user_api_keys)
    task.save

    task
  end
end
