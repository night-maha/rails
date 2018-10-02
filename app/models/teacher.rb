class Teacher < ApplicationRecord
  validates :name, {presence: true}
  validates :teacher_id, {presence: true, uniqueness: true}
  validates :password, {presence: true}
end
