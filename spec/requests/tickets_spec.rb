require 'rails_helper'

RSpec.describe "Tickets", type: :request do
  describe "GET /tickets" do
    it "returns a list of tickets belonging to the current user" do
      user = create(:user)
      token = generate_jwt_token(user)
      headers = { 'Authorization' => token }
      tickets = create_list(:ticket, 3, user: user)

      get "/tickets", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /tickets/:id" do
    it "returns a specific ticket belonging to the current user" do
      user = create(:user)
      token = generate_jwt_token(user)
      headers = { 'Authorization' => token }
      ticket = create(:ticket, user: user)

      get "/tickets/#{ticket.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['title']).to eq(ticket.title)
    end
  end

  describe "POST /tickets" do
    context "with valid parameters" do
      let(:user) { create(:user) }
      let(:token) { generate_jwt_token(user) }
      let(:headers) { { 'Authorization' => token } }
      let(:valid_params) do
        {
          ticket: {
            title: 'New Ticket',
            description: 'Description of the new ticket',
            status: 'new_unassigned'
          }
        }
      end

      it "creates a new ticket belonging to the current user" do
        post "/tickets", params: valid_params, headers: headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['title']).to eq('New Ticket')
      end
    end

    context "with invalid parameters" do
      let(:user) { create(:user) }
      let(:token) { generate_jwt_token(user) }
      let(:headers) { { 'Authorization' => token } }
      let(:invalid_params) do
        {
          ticket: {
            title: '',
            description: 'Description of the new ticket',
            status: 'new_unassigned'
          }
        }
      end

      it "returns unprocessable entity status" do
        post "/tickets", params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns errors in JSON response" do
        post "/tickets", params: invalid_params, headers: headers
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to include("can't be blank")
      end
    end
  end

  describe "PUT /tickets/:id" do
    let(:user) { create(:user) }
    let(:token) { generate_jwt_token(user) }
    let(:headers) { { 'Authorization' => token } }
    let(:ticket) { create(:ticket, user: user, title: 'Old Ticket') }

    context "with valid parameters" do
      let(:valid_params) do
        {
          ticket: {
            title: 'Updated Ticket',
            description: 'Updated description of the ticket',
            status: 'open_assigned'
          }
        }
      end

      it "updates the ticket" do
        put "/tickets/#{ticket.id}", params: valid_params, headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['title']).to eq('Updated Ticket')
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          ticket: {
            title: '',
            description: 'Updated description of the ticket',
            status: 'open_assigned'
          }
        }
      end

      it "returns unprocessable entity status" do
        put "/tickets/#{ticket.id}", params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns errors in JSON response" do
        put "/tickets/#{ticket.id}", params: invalid_params, headers: headers
        json_response = JSON.parse(response.body)
        expect(json_response['title']).to include("can't be blank")
      end
    end
  end

  describe "DELETE /tickets/:id" do
    let(:user) { create(:user) }
    let(:token) { generate_jwt_token(user) }
    let(:headers) { { 'Authorization' => token } }
    let(:ticket) { create(:ticket, user: user) }

    it "deletes the ticket" do
      delete "/tickets/#{ticket.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
