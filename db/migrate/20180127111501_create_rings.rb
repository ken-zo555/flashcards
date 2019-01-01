class CreateRings < ActiveRecord::Migration[5.0]
  def change
    create_table :rings do |t|
      t.string :ring_name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
