object @project

extends 'api/v1/projects/details.rabl'

node :tasks do
  partial 'api/v1/tasks/show', object: @project&.tasks
end