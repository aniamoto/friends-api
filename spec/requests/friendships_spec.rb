RSpec.describe 'Friendships API', type: :request do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user, blocks_users: [user2]) }
  let!(:user4) { create(:user) }
  let!(:user_with_friends) { create(:user, friends: [user3, user4]) }
  let(:user1_email) { user1.email }
  let(:user2_email) { user2.email }
  let(:user3_email) { user3.email }
  let(:user4_email) { user4.email }

  after(:all) do
    User.destroy_all
  end

  describe 'GET /api/v1/friends' do
    context 'when the user exists' do
      before { get "/api/v1/friends?email=#{user_with_friends.email}" }

      it 'returns friends of the user with count' do
        expect(json).not_to be_empty
        expect(json['friends']).to match_array([user3_email, user4_email])
        expect(json['count']).to eq(2)
      end

      it 'returns status code 200' do
        expect(response).to be_success
      end
    end

    context 'when the user does not exist' do
      email = 'no_user'
      before { get "/api/v1/friends?email=#{email}" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Object not found/)
      end
    end
  end

  describe 'GET /api/v1/mutual_friends' do
    context 'when the users exist' do
      before do
        get "/api/v1/mutual_friends?friends[]=#{user3_email}&friends[]=#{user4_email}"
      end

      it 'returns mutual friends with count' do
        expect(json).not_to be_empty
        expect(json['friends']).to match_array([user_with_friends.email])
        expect(json['count']).to eq(1)
      end

      it 'returns status code 200' do
        expect(response).to be_success
      end
    end

    context 'when one or both of the users do not exist' do
      email = 'no_user'
      before { get "/api/v1/mutual_friends?friends[]=#{user3_email}&friends[]=#{email}" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Object not found/)
      end
    end
  end

  describe 'POST /api/v1/friendships' do
    let(:valid_params) { { friends: [user1_email, user2_email] } }
    let(:invalid_params) { { friends: [user1_email, user1_email] } }
    let(:blocked_users) { { friends: [user2_email, user3_email] } }

    context 'when the request is valid' do
      context 'friendship is possible' do
        before { post '/api/v1/friendships', params: valid_params }

        it 'creates a friendship between users' do
          expect(user1.friends.to_a).to eq([user2])
          expect(user2.friends.to_a).to eq([user1])
        end

        it 'returns status code 200' do
          expect(response).to be_success
        end
      end

      context 'friendship is not possible' do
        before { post '/api/v1/friendships', params: blocked_users }

        it 'does not create a friendship between users' do
          expect(user2.friends.to_a).not_to include([user3])
          expect(user3.friends.to_a).not_to include([user2])
        end

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Cannot create friendship with blocked user/)
        end
      end
    end

    context 'when the request has missing params' do
      before { post '/api/v1/friendships', params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Two unique emails are required/)
      end
    end

    context 'when the request params are the same email' do
      before { post '/api/v1/friendships', params: invalid_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Two unique emails are required/)
      end
    end
  end
end
