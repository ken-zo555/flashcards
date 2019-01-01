class CreateCardRingLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :card_ring_links do |t|
      t.references :card, foreign_key: true
      t.references :ring, foreign_key: true

      t.timestamps
    end
  end
end
