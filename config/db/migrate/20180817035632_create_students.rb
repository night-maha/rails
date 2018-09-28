class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.integer :student_id
      t.string :password
      t.string :name
      t.string :sex
      t.date :birthday
      t.timestamps
    end
  end
end
