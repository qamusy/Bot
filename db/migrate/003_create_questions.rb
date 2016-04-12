class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions, force: true do |t|
      t.integer :question_id
      t.text :type
      t.text :option1
      t.text :option2
      t.text :option3
      t.text :option4
    end
  end
end
