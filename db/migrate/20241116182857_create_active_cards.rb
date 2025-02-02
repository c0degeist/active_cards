class CreateActiveCards < ActiveRecord::Migration[7.2]
  def change
    create_table :active_cards do |t|
      t.text :explanation
      t.text :answer
      t.text :question
      t.integer :level
      t.datetime :last_recal
      t.references :deck, index: true, foreign_key: true

      t.timestamps
    end
  end
end
