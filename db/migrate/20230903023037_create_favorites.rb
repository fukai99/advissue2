class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|

      t.timestamps
      t.integer :user_id
      t.integer :book_id
    end
  end
end
