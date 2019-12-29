object @task

extends 'api/v1/tasks/details.rabl'

node :comments do
  partial 'api/v1/comments/show', object: @task&.comments
end
