class Record < ApplicationRecord
  validates :year, presence: true
  validates :semester, presence: true
  belongs_to :student, foreign_key: "student_id"
end
