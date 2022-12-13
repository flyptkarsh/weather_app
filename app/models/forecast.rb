# frozen_string_literal: true

class Forecast < ApplicationRecord
  validates :zip_code, presence: true, uniqueness: true
  validates :current_temperature, presence: true

  def last_updated_over_30_minutes_ago?
    return true if new_record?

    updated_at <= 30.minutes.ago
  end
end
