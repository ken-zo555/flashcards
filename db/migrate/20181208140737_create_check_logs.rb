class CreateCheckLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :check_logs do |t|
      t.references :user, foreign_key: true
      t.references :ring, foreign_key: true
      t.integer :period
      t.integer :period_of_ring
      t.string :status
      t.integer :total_question
      t.integer :solved_question
      t.integer :correct_question
      t.integer :false_question

      t.timestamps
    end
  end
end
