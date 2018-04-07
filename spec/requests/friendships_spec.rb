RSpec.describe 'Friendships API', type: :request do
  let!(:user1) { User.create!(email: "#{rand(36**8).to_s(36)}@example.com") }
  let!(:user2) { User.create!(email: "#{rand(36**8).to_s(36)}@example.com") }
  let(:user1_email) { user1.email }
  let(:user2_email) { user2.email }

  after(:all) do
    User.destroy_all
  end

  describe 'POST /api/v1/friends' do
    let(:valid_params) { { friends: [user1_email, user2_email] } }

    context 'when the request is valid' do
      before { post '/api/v1/friends', params: valid_params }

      it 'creates a friendship between users' do
        expect(user1.friends.to_a).to eq([user2])
        expect(user2.friends.to_a).to eq([user1])
      end

      it 'returns status code 200' do
        expect(response).to be_success
      end
    end

    context 'when the request has missing params' do
      before { post '/api/v1/friends', params: { friends: [] } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Friendship creation requires two emails/)
      end
    end

    context 'when the request params are the same email' do
      before { post '/api/v1/friends', params: { friends: [user1_email, user1_email] } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/User cannot friend themselves!/)
      end
    end
  end
end
