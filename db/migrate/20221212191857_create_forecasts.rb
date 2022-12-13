# frozen_string_literal: true

class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :forecasts do |t|
      t.string :zip_code
      t.integer :current_temperature

      t.timestamps
    end
  end
end
