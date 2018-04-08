RSpec.describe 'Friendships API', type: :request do
  let!(:user1) { User.create!(email: "#{rand(36**8).to_s(36)}@example.com") }
  let!(:user2) { User.create!(email: "#{rand(36**8).to_s(36)}@example.com") }
  let(:user1_email) { user1.email }
  let(:user2_email) { user2.email }

  after(:all) do
    User.destroy_all
  end

  describe 'POST /api/v1/block_user' do
    let(:valid_params) { { requestor: user1_email, target: user2_email } }
    let(:invalid_params) { { requestor: user1_email, target: user1_email } }

    context 'when the request is valid' do
      before { post '/api/v1/block_user', params: valid_params }

      it 'blocks the target for the requestor' do
        expect(user1.blocks_users.to_a).to eq([user2])
      end

      it 'adds the requestor to blocked_by for the target' do
        expect(user2.blocked_by.to_a).to eq([user1])
      end

      it 'returns status code 200' do
        expect(response).to be_success
      end
    end

    context 'when the request has missing params' do
      before { post '/api/v1/block_user', params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Two unique emails are required/)
      end
    end

    context 'when the request params are the same email' do
      before { post '/api/v1/block_user', params: invalid_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Two unique emails are required/)
      end
    end
  end
end
