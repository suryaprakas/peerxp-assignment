class CreateTableProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :description
      t.references :user, foreign_key: true
    end
  end
end
