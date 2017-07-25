require 'spec_helper'

describe JsonApiReader::PageResult do
  let(:body) { JSON.parse(fixture('opened-events.json')) }
  subject { described_class.new(body) }

  its('attributes.count') { is_expected.to eq(3) }
  its(:next_url) { is_expected.to eq('https://my-endpoint.com/api/v1/some-json-api-feed?page=2') }
  its(:data) { is_expected.to eq(body['data']) }
  its(:meta) { is_expected.to eq(body['meta']) }
  its(:links) { is_expected.to eq(body['links']) }
  its(:self_url) { is_expected.to eq(body['links']['self']) }
  its(:next_url) { is_expected.to eq(body['links']['next']) }

  it 'filters attributes by type' do
    by_type = subject.attributes_by_type('event-trackings')
    expect(by_type.collect { |typ| typ['id'] }).to eq([820, 819, 659])
  end

  it 'finds by type and id' do
    found = subject.attributes_by_type_and_id('event-trackings', 819)
    expect(found['id']).to eq(819)
  end

  context 'with relationships' do
    let(:body) { JSON.parse(fixture('cls-api-v2-leads.json')) }

    it 'finds included by type and id' do
      found = subject.included_by_type_and_id('voicestar-call-payloads', 649936)
      expect(found['id']).to eq('649936')
    end
  end

  describe '#convert_dash_keys_to_underscore!' do
    let(:body) { JSON.parse(fixture('cls-api-v2-leads.json')) }
    before { subject.convert_dash_keys_to_underscore! }

    it 'converts location-urn to location_urn' do
      expect(subject.attributes.first['location_urn']).to eq('g5-cl-53gncjftn-storquest-san-rafael-golden-gate-1015')
    end

    it 'converts included attributes too' do
      found = subject.included_by_type_and_id('voicestar-call-payloads', 649934)['attributes']
      expect(found['made_up']).to eq('foo')
    end
  end
end