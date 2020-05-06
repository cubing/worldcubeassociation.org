# frozen_string_literal: true

class CreateRegionsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :regions do |t|
      t.string :name, null: false
      t.string :friendly_id, null: false
      t.boolean :is_active, null: false
    end

    add_index :regions, :friendly_id
  end
end
