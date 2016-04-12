class CreateWords < ActiveRecord::Migration
  def change
    create_table :words, force: true do |t|
      t.integer :word_id
      t.text :word
      t.text :arabic
      t.text :definition
    end
  end
end
