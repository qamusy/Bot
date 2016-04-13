class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, force: true do |t|
      t.integer :uid
      t.text :username
      t.text :first_name
      t.text :last_name
      t.text :lang, :default => "en"
      t.text :last_command
      t.date :create_date
      t.text :location
    end
  end
end
