class Project < ApplicationRecord
  #validations
  validates :name, presence: true
  validates :user_id, presence: true

  #associations
  belongs_to :user
  has_many :tasks
end