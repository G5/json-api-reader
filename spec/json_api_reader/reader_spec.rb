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

  let(:endpoint) { 'https://my-endpoint.com/api/v1/some-json-api-feed' }
  let(:test_yield) { TestYield.new }

  let(:first_page_response) { fixture('opened-events.json') }
  let(:second_page_response) { fixture('opened-events-2.json') }
  let(:params) { {endpoint: endpoint} }

  describe '#first_page' do
    context 'without endpoint' do
      let(:endpoint) { nil }
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

    # typical G5 usage
    # class MyClass
    #   extends G5AuthenticationClient::AuthTokenHelper
    # end
    #
    # JsonApiReader::Reader.first_page({endpoint: my_endpoint, token_retriever_class: MyClass, token_retriever_method: do_with_username_pw_access_token})
    #
    context 'with token_retriever_class' do
      class Foo
        def self.bar
          yield 'mytoken'
        end
      end

      let(:params) do
        {token_retriever_class:  Foo,
         token_retriever_method: :bar,
         endpoint:               endpoint
        }
      end
      before do
        stub_request(:get, endpoint).
            with(headers: {'Accept' => 'application/json', 'Authorization' => 'Bearer mytoken', 'Content-Type' => 'application/json'}).
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

  describe '#all_pages' do
    context 'success' do
      before do
        stub_request(:get, endpoint).
            with(headers: {'Accept' => 'application/json', 'Content-Type' => 'application/json'}).
            to_return(status: 200, body: first_page_response, headers: {})
        stub_request(:get, 'https://my-endpoint.com/api/v1/some-json-api-feed?page=2').
            with(headers: {'Accept' => 'application/json', 'Content-Type' => 'application/json'}).
            to_return(status: 200, body: second_page_response, headers: {})
        described_class.all_pages(params) do |result|
          test_yield.on_yield(result)
        end
      end

      it 'yielded the result' do
        expect(test_yield.yielded.count).to eq(2)
        expect(test_yield.yielded.first.attributes.count).to eq(3)
        expect(test_yield.yielded.last.attributes.count).to eq(1)
      end
    end

    context 'breaking out after first page' do
      before do
        stub_request(:get, endpoint).
            with(headers: {'Accept' => 'application/json', 'Content-Type' => 'application/json'}).
            to_return(status: 200, body: first_page_response, headers: {})
        described_class.all_pages(params) do |result|
          test_yield.on_yield(result)
          break
        end
      end

      it 'yielded the result' do
        expect(test_yield.yielded.count).to eq(1)
        expect(test_yield.yielded.first.attributes.count).to eq(3)
      end
    end
  end
end