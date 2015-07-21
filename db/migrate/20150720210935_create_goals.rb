class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :title, null: false
      t.text :description
      t.integer :user_id, null: false, index: true, foreign_key: true
      t.boolean :private, null: false

      t.timestamps null: false
    end
  end
end
