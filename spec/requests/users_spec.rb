RSpec.describe 'Users API', type: :request do
  let!(:user) { User.create!(email: "#{rand(36**8).to_s(36)}@example.com") }
  let(:user_id) { user.id }

  after(:all) do
    User.destroy_all
  end

  describe 'GET /api/v1/users' do
    before { get '/api/v1/users' }

    it 'returns users' do
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end

    it 'returns status code 200' do
      expect(response).to be_success
    end
  end

  describe 'GET /api/v1/users/:id' do
    context 'when the record exists' do
      before { get "/api/v1/users/#{user_id}" }

      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['user']['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to be_success
      end
    end

    context 'when the record does not exist' do
      user_id = 'no_user'
      before { get "/api/v1/users/#{user_id}" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Object not found/)
      end
    end
  end

  describe 'POST /api/v1/users' do
    let(:email) { "#{rand(36**8).to_s(36)}@example.com" }
    let(:valid_attributes) { { email: email } }

    context 'when the request is valid' do
      before { post '/api/v1/users', params: valid_attributes }

      it 'creates a user' do
        expect(json['user']['email']).to eq(email)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/users', params: { email: '' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Email can't be blank/)
      end
    end
  end

  describe 'PUT /api/v1/users/:id' do
    let(:valid_attributes) { { email: 'anna@example.com' } }

    context 'when the record exists' do
      before { put "/api/v1/users/#{user_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    before { delete "/api/v1/users/#{user_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
