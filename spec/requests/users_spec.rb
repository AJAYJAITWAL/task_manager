require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "returns a list of users" do
      FactoryBot.create_list(:user, 3)
      token = generate_jwt_token(User.first)
      headers = { 'Authorization' => token }

      get "/users", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "POST /users" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          name: 'John Doe',
          username: 'johndoe',
          email: 'john@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      end

      it "creates a new user" do
        FactoryBot.create(:user)
        token = generate_jwt_token(User.first)
        headers = { 'Authorization' => token }

        post '/users', params: valid_params, headers: headers
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          name: 'John',
          username: 'johndoe',
          email: '',
          password: 'password',
          password_confirmation: 'password'
        }
      end

      it "returns unprocessable entity status" do
        FactoryBot.create(:user)
        token = generate_jwt_token(User.first)
        headers = { 'Authorization' => token }

        post '/users', params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns errors in JSON response" do
        FactoryBot.create(:user)
        token = generate_jwt_token(User.first)
        headers = { 'Authorization' => token }

        post '/users', params: invalid_params, headers: headers
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Email can't be blank")
      end
    end
  end
end
