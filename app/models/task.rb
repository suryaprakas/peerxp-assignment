class Task < ApplicationRecord
  #validations
  validates :name, presence: true

  #associations
  belongs_to :project

  module Status
    FRESH = 'fresh'.freeze
    DONE = 'done'.freeze
    ALL = Task::Status.constants.map{ |roles| Task::Status.const_get(roles) }.flatten.uniq
  end

  module Priority
    HIGH = 'high'.freeze
    MEDIUM = 'medium'.freeze
    LOW = 'low'.freeze
    ALL = Task::Priority.constants.map{ |roles| Task::Priority.const_get(roles) }.flatten.uniq
  end

  enum status: [ :fresh, :done]
  enum priority: [ :high, :medium, :low]
end