class CreateUserWords < ActiveRecord::Migration
  def change
    create_table :userwords, force: true do |t|
      t.integer :user_id
      t.integer :word_id
      t.integer :attempts
      t.integer :succeeded
      t.integer :failed
    end
  end
end
