class CreateActiveCards < ActiveRecord::Migration[7.2]
  def change
    create_table :active_cards do |t|
      t.text :explanation
      t.text :answer
      t.text :question
      t.integer :level
      t.datetime :last_recal

      t.timestamps
    end
  end
end
