require 'spec_helper'

describe JsonApiReader::Fetcher do
  let(:url) { 'http://my-endpoint.com' }
  let(:query) { {foo: :bar} }
  let(:options) { {query: query, headers: {'Authorization' => 'Bearer token'}} }
  subject { described_class.new(url, options) }

  its(:query) { is_expected.to eq(query) }
  its(:headers) { is_expected.to eq({'Content-Type'  => 'application/json',
                                     'Accept'        => 'application/json',
                                     'Authorization' => 'Bearer token'}) }

  describe '#fetch_all' do
    context 'errors' do
      before do
        expect(HTTParty).to receive(:get).and_return(double(:response, code: code))
      end
      context '404' do
        let(:code) { 404 }

        it 'raises record-not-found' do
          expect { described_class.fetch_all(url, options) }.to raise_error(JsonApiReader::RecordNotFoundError)
        end
      end

      context '401' do
        let(:code) { 401 }

        it 'raises not-authorized' do
          expect { described_class.fetch_all(url, options) }.to raise_error(JsonApiReader::NotAuthorizedError)
        end
      end

      context '500' do
        let(:code) { 500 }

        it 'raises error' do
          expect { described_class.fetch_all(url, options) }.to raise_error(JsonApiReader::Error)
        end
      end
    end

    context 'success' do
      subject { described_class.fetch_all(url, {}) }
      let(:expected_params) do
        {query: nil, headers: {'Content-Type' => 'application/json',
                               'Accept'       => 'application/json'}}
      end

      before do
        allow(HTTParty).to receive(:get).and_return(double(:response, code: 200, body: fixture('opened-events.json')))
        subject
      end

      it 'calls get with correct params' do
        expect(HTTParty).to have_received(:get).with(url, expected_params)
      end

      it 'returns page-result' do
        expect(subject).to be_kind_of(JsonApiReader::PageResult)
        expect(subject.attributes.count).to eq(3)
      end
    end
  end

  context 'without options' do
    let(:options) { {} }

    its(:query) { is_expected.to be_nil }
    its(:headers) { is_expected.to eq({'Content-Type' => 'application/json',
                                       'Accept'       => 'application/json'}) }
  end
end