class AddColumToCheckCards < ActiveRecord::Migration[5.0]
  def change
    add_column :check_cards, :num_of_log, :integer
  end
end
