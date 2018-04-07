RSpec.describe 'Friendships API', type: :request do
  let!(:user1) { User.create!(email: "#{rand(36**8).to_s(36)}@example.com") }
  let!(:user2) { User.create!(email: "#{rand(36**8).to_s(36)}@example.com") }
  let!(:user3) { User.create!(email: "#{rand(36**8).to_s(36)}@example.com") }
  let!(:user4) { User.create!(email: "#{rand(36**8).to_s(36)}@example.com") }
  let!(:user_with_friends) do
    User.create!(
      email: "#{rand(36**8).to_s(36)}@example.com",
      friends: [user3]
    )
  end
  let!(:user_with_subscriptions) do
    User.create!(
      email: "#{rand(36**8).to_s(36)}@example.com",
      subscriptions: [user4]
    )
  end
  let(:user1_email) { user1.email }
  let(:user2_email) { user2.email }

  after(:all) do
    User.destroy_all
  end

  describe 'POST /api/v1/subscriptions' do
    let(:valid_params) { { requestor: user1_email, target: user2_email } }
    let(:invalid_params) { { requestor: user1_email, target: user1_email } }

    context 'when the request is valid' do
      before { post '/api/v1/subscriptions', params: valid_params }

      it 'creates a subscription for the requestor' do
        expect(user1.subscriptions.to_a).to eq([user2])
      end

      it 'creates a subscriber for the target' do
        expect(user2.subscribers.to_a).to eq([user1])
      end

      it 'returns status code 200' do
        expect(response).to be_success
      end
    end

    context 'when the request has missing params' do
      before { post '/api/v1/subscriptions', params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Two unique emails are required/)
      end
    end

    context 'when the request params are the same email' do
      before { post '/api/v1/subscriptions', params: invalid_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Two unique emails are required/)
      end
    end
  end
end
