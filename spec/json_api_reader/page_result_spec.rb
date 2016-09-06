require 'spec_helper'

describe JsonApiReader::PageResult do
  let(:body) { JSON.parse(fixture('opened-events.json')) }
  subject { described_class.new(body) }

  its('attributes.count') { is_expected.to eq(3) }
  its(:next_url) { is_expected.to eq('https://my-endpoint.com/api/v1/some-json-api-feed?page=2') }

  it 'filters attributes by type' do
    by_type = subject.attributes_by_type('event-trackings'.to_sym)
    expect(by_type.collect { |typ| typ[:id] }).to eq([])
  end
end