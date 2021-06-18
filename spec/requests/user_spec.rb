require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:new_user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end

  describe 'Sign Up' do
    context 'when valid params' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(:created)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when invalid params' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Validation failed: Password can't be blank, Name can't be blank, Email can't be blank/)
      end
    end
  end

  describe 'Index' do
    context 'when valid request' do
      before { get "/users/", params: {}, headers: valid_headers }

      it 'creates a new user' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns success message' do
        first_user = json.first

        expect(first_user["id"]).to eq(user.id)
        expect(first_user["name"]).to eq(user.name)
        expect(first_user["email"]).to eq(user.email)
        expect(first_user["state"]).to eq(user.state)
        expect(first_user["created_at"]).to eq(user.created_at.iso8601(3))
        expect(first_user["updated_at"]).to eq(user.updated_at.iso8601(3))
      end
    end
  end

  describe 'Show' do
    context 'when valid params' do
      before { get "/users/#{user.id}", params: {}, headers: valid_headers }

      it 'creates a new user' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct attributes' do
        expect(json["id"]).to eq(user.id)
        expect(json["name"]).to eq(user.name)
        expect(json["email"]).to eq(user.email)
        expect(json["state"]).to eq(user.state)
        expect(json["created_at"]).to eq(user.created_at.iso8601(3))
        expect(json["updated_at"]).to eq(user.updated_at.iso8601(3))
      end
    end

    context 'when invalid user_id' do
      before { get "/users/-100", params: {}, headers: valid_headers }

      it 'returns not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns failure message' do
        expect(json['message']).to match(/Couldn't find User with 'id'=-100/)
      end
    end
  end

  describe 'Create' do
    context 'when valid params' do
      before do
        @params = {
          name: "Chandra",
          email: "chandra@gmail.com",
          password: "12345",
          password_confirmation: "12345"
        }
        post "/users/", params: @params.to_json, headers: valid_headers
      end

      it 'creates a new user' do
        expect(response).to have_http_status(:created)
      end

      it 'returns correct attributes' do
        user = User.find(json["user"]["id"])

        expect(json["auth_token"]).not_to eq(nil)
        expect(json["message"]).to eq("Account created successfully")
        expect(json["user"]["id"]).to eq(user.id)
        expect(json["user"]["name"]).to eq(@params[:name])
        expect(json["user"]["email"]).to eq(@params[:email])
        expect(json["user"]["state"]).to eq("active")
        expect(json["user"]["created_at"]).to eq(user.created_at.iso8601(3))
        expect(json["user"]["updated_at"]).to eq(user.updated_at.iso8601(3))
      end
    end

    context 'when invalid params' do
      before { post "/users/", params: {}, headers: valid_headers }

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Validation failed: Password can't be blank, Name can't be blank, Email can't be blank, Email is invalid/)
      end
    end
  end

  describe 'Destroy' do
    context 'when valid user_id' do
      before { delete "/users/#{user.id}", params: {}, headers: valid_headers }

      it 'returns ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct attributes' do
        user.reload
        expect(json["message"]).to eq("Account deleted successfully")
        expect(json["user"]["id"]).to eq(user.id)
        expect(json["user"]["name"]).to eq(user.name)
        expect(json["user"]["email"]).to eq(user.email)
        expect(json["user"]["state"]).to eq("deleted")
        expect(json["user"]["created_at"]).to eq(user.created_at.iso8601(3))
        expect(json["user"]["updated_at"]).to eq(user.updated_at.iso8601(3))
      end
    end

    context 'when invalid user_id' do
      before { delete "/users/-100", params: {}, headers: valid_headers }

      it 'returns not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns failure message' do
        expect(json['message']).to match(/Couldn't find User with 'id'=-100/)
      end
    end
  end

  describe 'Update' do
    context 'when valid params' do
      before do
        @params = {
          name: "Chandra Phang",
          email: "chandraphang@gmail.com",
          state: "deleted"
        }
        patch "/users/#{user.id}", params: @params.to_json, headers: valid_headers
      end

      it 'returns ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct attributes' do
        expect(json["message"]).to eq("Account updated successfully")
        expect(json["user"]["id"]).not_to eq(nil)
        expect(json["user"]["name"]).to eq(@params[:name])
        expect(json["user"]["email"]).to eq(@params[:email])
        expect(json["user"]["state"]).to eq(@params[:state])
        expect(json["user"]["created_at"]).not_to eq(nil)
        expect(json["user"]["updated_at"]).not_to eq(nil)
      end
    end

    context 'when invalid params' do
      before { patch "/users/#{user.id}", params: { state: "a" }.to_json, headers: valid_headers }

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns failure message' do
        expect(json['message']).to match("Parameter state must be within [\"active\", \"deleted\"]")
      end
    end

    context 'when invalid user_id' do
      before { patch "/users/-100", params: { state: "deleted" }.to_json, headers: valid_headers }

      it 'returns not_found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns failure message' do
        expect(json['message']).to match(/Couldn't find User with 'id'=-100/)
      end
    end
  end
end
