class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :content_1
      t.string :content_2
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
