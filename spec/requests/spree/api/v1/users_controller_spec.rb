require 'spec_helper'

describe Spree::Api::V1::UsersController do
  let(:user) { Spree.user_class.last }
  let(:json_response) { JSON.parse response.body }
  let(:params) { {spree_user: {email: 'john@example.com', password: 'password'}} }
  before { $valid_test_password = nil }

  describe 'sign up' do
    let(:endpoint) { '/api/v1/users/sign_up' }
    before { params[:spree_user][:password_confirmation] = params[:spree_user][:password] }

    it 'will create a new user with an API token' do
      expect { post endpoint, params }.to change { Spree.user_class.count }.by 1

      expect( response ).to have_http_status 200
      expect( json_response['email'] ).to eq user.email
      expect( json_response['spree_api_key'] ).to eq user.spree_api_key
    end

    it 'will return 422 and validation message if error' do
      create :user, email: params[:spree_user][:email]
      expect { post endpoint, params }.to change { Spree.user_class.count }.by 0
      expect( response ).to have_http_status 422
      expect( json_response['errors']['email'] ).to eq ['has already been taken']
    end
  end

  describe 'sign in' do
    let(:endpoint) { '/api/v1/users/sign_in' }

    it 'will return the user profile and API key if valid' do
      user = create :user, email: params[:spree_user][:email], password: 'password'
      post endpoint, params
      user.reload

      expect( response ).to have_http_status 200
      expect( json_response['email'] ).to eq user.email
      expect( json_response['spree_api_key'] ).to eq user.spree_api_key
    end

    it 'will return 401 unauthorized if password invalid' do
      params[:spree_user][:password] = 'invalid'
      user = create :user, email: params[:spree_user][:email]
      post endpoint, params
      expect( response ).to have_http_status 401
    end

    it 'will return 404 not found if user not found' do
      post endpoint, params
      expect( response ).to have_http_status 404
    end
  end
end
