class AddTopicToTestsAndRemoveDeck < ActiveRecord::Migration[7.2]

  def change
    add_column :tests, :topic_id, :integer
    remove_column :tests, :deck_id
  end

end
