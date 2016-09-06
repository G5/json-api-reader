require 'spec_helper'

describe JsonApiReader::Reader do
  class TestYield
    attr_reader :yielded

    def initialize
      @yielded = Array.new
    end

    def on_yield(params)
      @yielded << params
    end
  end

  let(:test_yield) { TestYield.new }

  let(:first_page_response) { fixture('opened-events.json') }
  let(:params) { {endpoint: endpoint} }

  describe '#first_page' do
    let(:endpoint) { nil }
    context 'without endpoint' do
      it 'raises informative error' do
        expect { described_class.first_page(params) }.to raise_error("'endpoint' option is required")
      end
    end

    context 'endpoint not found' do
      let(:endpoint) { 'http://where-are-you.com' }
      before do
        stub_request(:get, endpoint).
            with(headers: {'Accept' => 'application/json', 'Content-Type' => 'application/json'}).
            to_return(status: 404, body: first_page_response, headers: {})
      end
      it 'raises informative error' do
        expect { described_class.first_page(params) }.to raise_error(JsonApiReader::RecordNotFoundError)
      end
    end

    context 'success' do
      let(:endpoint) { 'https://my-endpoint.com/api/v1/some-json-api-feed' }

      before do
        stub_request(:get, endpoint).
            with(headers: {'Accept' => 'application/json', 'Content-Type' => 'application/json'}).
            to_return(status: 200, body: first_page_response, headers: {})
        described_class.first_page(params) do |result|
          test_yield.on_yield(result)
        end
      end

      it 'yielded the result' do
        expect(test_yield.yielded.count).to eq(1)
        expect(test_yield.yielded.first.attributes.count).to eq(3)
      end
    end
  end
end