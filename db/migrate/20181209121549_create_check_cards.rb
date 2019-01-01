class CreateCheckCards < ActiveRecord::Migration[5.0]
  def change
    create_table :check_cards do |t|
      t.references :check_log, foreign_key: true
      t.string :content_1
      t.string :content_2

      t.timestamps
    end
  end
end
