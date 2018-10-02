class CreateTeachers < ActiveRecord::Migration[5.2]
  def change
    create_table :teachers do |t|
      t.integer :teacher_id
      t.string :name
      t.string :password

      t.timestamps
    end
  end
end
