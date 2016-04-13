class CreateWords < ActiveRecord::Migration
  def change
    create_table :words, force: true do |t|
      t.text :word
      t.text :category
      t.text :arabic
      t.text :definition
    end
  end
end
