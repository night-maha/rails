class Record < ApplicationRecord
  validates :jpn, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :math, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :eng, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :sci, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :soc, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :year, presence: true
  validates :semester, presence: true
  belongs_to :student, foreign_key: "student_id"
end
