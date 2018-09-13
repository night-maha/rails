class RemoveEmailPasswordFromStudents < ActiveRecord::Migration[5.2]
  def change
    remove_columns :students, :email, :password
  end
end
