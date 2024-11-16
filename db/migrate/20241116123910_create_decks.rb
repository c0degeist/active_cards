class CreateDecks < ActiveRecord::Migration[7.2]
  def change
    create_table :decks do |t|
      t.string :title

      t.timestamps
    end
  end
end
