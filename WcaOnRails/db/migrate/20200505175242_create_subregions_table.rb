# frozen_string_literal: true

class CreateSubregionsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :subregions do |t|
      t.string :name, null: false
      t.references :region, null: false
      t.string :friendly_id, null: false
    end

    add_index :subregions, :friendly_id
  end
end
