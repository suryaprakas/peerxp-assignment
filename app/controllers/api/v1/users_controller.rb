class Api::V1::UsersController < ApplicationController
    swagger_controller :users, 'Users Manager'

    swagger_api :list_trainer do
      summary 'Returns all posts'
      notes 'Notes...'
    end

    def list_trainer
      render json: {message: "posts"}, status: :ok
    end
end