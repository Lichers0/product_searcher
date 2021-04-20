# frozen_string_literal: true

class Task < ApplicationRecord
  has_one_attached :file

  validates :email, :seller_id, :mws_auth_token, :ship_to_fba, :services_cost, presence: true
  validates :file, attached: true
  validate  :csv_header_errors?, :api_errors?

  private

  def api_errors?
    errors.add(:wrong_keys, "amazon keys errors") if ApiChecker.call(self).error?
  end

  def csv_header_errors?
    return true if file.blank?

    temp_file = attachment_changes["file"].attachable
    errors.add(:wrong_csv_header, "don't find columns") if CsvHeaderChecker.call(temp_file).error?
  end
end
