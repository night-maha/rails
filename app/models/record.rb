class Record < ApplicationRecord
  validates :year, presence: true
  validates :semester, presence: true
end
