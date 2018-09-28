class CreateAssessings < ActiveRecord::Migration[5.2]
  def change
    create_table :assessings do |t|
      t.integer :student_id
      t.integer :jpn
      t.integer :math
      t.integer :eng
      t.integer :sci
      t.integer :soc
      t.column :year, 'year(4)'
      t.integer :semester
      t.timestamps
    end
  end
end
