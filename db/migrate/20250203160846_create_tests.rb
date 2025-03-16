class CreateTests < ActiveRecord::Migration[7.2]

  def change
    create_table :tests do |t|
      t.references :deck
      t.string :state
      t.datetime :finished_at
      t.integer :cards_count
      t.timestamps
    end
  end

end
