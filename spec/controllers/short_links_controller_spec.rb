require 'rails_helper'

RSpec.describe ShortLinksController, type: :controller do
  describe 'GET #show' do
    let!(:short_link) { create(:short_link) }
    let(:request) { get :show, params: { id: short_link.encoded_id, user_id: 1 } }

    context 'with a valid short link' do
      it 'responds with a 301' do
        request
        expect(response).to have_http_status(:moved_permanently)
      end

      it 'redirects to the long_url' do
        expect(request).to redirect_to(short_link.long_link)
      end
    end

    context 'with a missing short_link' do
      before(:each) do
        allow(ShortLink).to receive(:find_by_encoded_id).and_return(nil)
      end

      it 'returns a 404' do
        request
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    let(:params) { {} }
    let(:request) { post :create, params: params }

    context 'with valid params' do
      let(:long_link) { 'https://www.google.com' }
      let(:params) { { long_link: long_link, user_id: 1 } }

      it 'returns a 201' do
        request
        expect(response).to have_http_status(:created)
      end

      it 'creates a short_link' do
        expect { request }.to change(ShortLink, :count).by(1)
      end

      it 'returns payload' do
        request
        expect(JSON.parse(response.body))
          .to eq('long_link' => long_link, 'short_link' => "http://test.host/#{ShortLink.last.encoded_id}")
      end
    end

    context 'with duplicate long_link' do
      let(:long_link) { 'https://www.google.com' }
      let!(:short_link) { create(:short_link, long_link: long_link, user_id: 1) }
      let(:params) { { long_link: long_link, user_id: 1 } }

      it 'returns a 201' do
        request
        expect(response).to have_http_status(:created)
      end

      it 'does not create a short_link' do
        expect { request }.to change(ShortLink, :count).by(0)
      end

      it 'returns payload' do
        request
        expect(JSON.parse(response.body))
          .to eq('long_link' => long_link, 'short_link' => "http://test.host/#{short_link.encoded_id}")
      end
    end

    context 'with invalid params' do
      context 'missing long_link' do
        let(:params) { { long_link: nil, user_id: 1 } }

        it 'returns a 422' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error' do
          request
          expect(JSON.parse(response.body)).to eq('long_link' => ["can't be blank", 'is invalid'])
        end
      end

      context 'invalid url' do
        let(:params) { { long_link: 'invalid', user_id: 1 } }

        it 'returns a 422' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error' do
          request
          expect(JSON.parse(response.body)).to eq('long_link' => ['is invalid'])
        end
      end
    end
  end
  
  describe "Analytics" do

    params = { long_link: 'https://www.google.com', user_id: 1 }
    no_dup_params =  { long_link: 'https://www.google.com', user_id: 2 }
    cached_response = nil

    let(:create_request) { post :create, params: params }
    let(:create_no_dup_request) { post :create, params: no_dup_params }

    before(:each) do
      cached_response = post(:create, params: params)
    end

    context 'create with valid params' do

      it 'returns a 201' do
        expect(cached_response).to have_http_status(:created)
      end

      it 'should have a use_count of 1' do
        expect(ShortLink.find_quietly(:last).use_count).to eq(1)
      end

      it 'create duplicate should increase use_count to 2' do
        create_request
        expect(ShortLink.find_quietly(:last).use_count).to eq(2)
      end

      it 'non duplicate params should have use_count eq 1' do
        create_request
        create_no_dup_request
        expect(ShortLink.find_quietly(:last).use_count).to eq(1)
      end

      it 'use count via request should also eq 1' do
        create_no_dup_request
        short_link = ShortLink.find_quietly(:last)
        get(:analytics, params: {id: short_link.encoded_id})
        expect(JSON.parse(response.body))
            .to eq('long_link' => short_link.long_link, 'short_link' => "http://test.host/#{short_link.encoded_id}", 'use_count' => "1")
      end
    end

  end
end