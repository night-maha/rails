class ChangeAuthenticationColumnsOnStudents < ActiveRecord::Migration[5.2]
  def change
    add_index :students, :student_id, :unique => true
  end
end
