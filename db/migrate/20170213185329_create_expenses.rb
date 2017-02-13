class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      t.string :category
      t.integer :budget
      t.integer :user_id

      t.timestamps
    end
  end
end
