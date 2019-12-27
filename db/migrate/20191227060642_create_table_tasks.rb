class CreateTableTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string :description
      t.integer :status
      t.integer :priority
      t.date :dead_line
      t.references :project, foreign_key: true
    end
  end
end
