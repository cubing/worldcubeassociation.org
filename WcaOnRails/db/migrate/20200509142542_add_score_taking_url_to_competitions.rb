# frozen_string_literal: true

class AddScoreTakingUrlToCompetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :Competitions, :score_taking_url, :string, null: true, default: nil
  end
end
