require 'active_job'
require 'active_job/arguments'
require 'rails_values/http_url_serializer'

module RailsValues
  RSpec.describe HttpUrlSerializer do
    subject { described_class.instance }

    it 'can cast and serialize' do
      value = HttpUrl.cast('http://www.example.com')
      value_serialized = subject.serialize(value)
      value_casted = subject.deserialize(value_serialized)

      expect(value_serialized).to be_a(Hash)
      expect(value_casted).to eq(value)
    end
  end
end
