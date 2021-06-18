class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def index
    users = User.all
    output = users.map { |user| user_output(user) }
    json_response(output)
  end

  def show
    user = User.find(params[:id])
    json_response(user_output(user))
  end

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = {
      auth_token: auth_token,
      message: Message.account_created,
      user: user_output(user)
    }
    json_response(response, :created)
  end

  def update
    user = User.find(params[:id])
    user.update!(user_params)
    response = {
      message: Message.account_updated,
      user: user_output(user)
    }
    json_response(response)
  end

  def destroy
    user = User.find(params[:id])
    user.deleted!
    response = {
      message: Message.account_deleted,
      user: user_output(user)
    }
    json_response(response)
  end

  private

  def user_params
    param! :id,                     Integer
    param! :name,                   String
    param! :email,                  String
    param! :state,                  String, in: User.states.keys
    param! :password,               String
    param! :password_confirmation,  String

    params.permit(:id, :name, :email, :state, :password, :password_confirmation)
  end

  def user_output(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      state: user.state,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
