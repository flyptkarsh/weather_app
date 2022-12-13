# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:zip_code) }
    it { should validate_uniqueness_of(:zip_code) }
    it { should validate_presence_of(:current_temperature) }
  end

  describe '#last_updated_over_30_minutes_ago?' do
    it 'returns true if the record is new' do
      expect(described_class.new.last_updated_over_30_minutes_ago?).to be true
    end

    it 'returns true if the record is older than 30 minutes' do
      forecast = described_class.new(updated_at: 31.minutes.ago)
      expect(forecast.last_updated_over_30_minutes_ago?).to be true
    end

    it 'returns false if the record is less than 30 minutes old' do
      forecast = described_class.create(updated_at: 10.minutes.ago, zip_code: '12345', current_temperature: '50')
      expect(forecast.last_updated_over_30_minutes_ago?).to be false
    end
  end
end
