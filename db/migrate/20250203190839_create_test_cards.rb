class CreateTestCards < ActiveRecord::Migration[7.2]

  def change
    create_table :test_cards do |t|
      t.text :explanation
      t.text :answer
      t.text :user_answer
      t.text :question
      t.string :state
      t.boolean :answered_correctly
      t.references :test, index: true, foreign_key: true
      t.references :active_card, index: true, foreign_key: true

      t.timestamps
    end
  end

end
