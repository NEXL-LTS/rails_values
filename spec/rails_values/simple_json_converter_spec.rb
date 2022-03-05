require 'rails_values/simple_json_converter'
require 'rails_values/industry_list'

module RailsValues
  RSpec.describe SimpleJsonConverter do
    subject { described_class.new(IndustryList) }

    it 'can cast and serialize' do
      value = IndustryList.cast(%w[101010 202010])
      value_serialized = subject.serialize(value)
      value_casted = subject.cast(value_serialized)

      expect(value_serialized).to be_a(String)
      expect(value_casted).to eq(value)
    end
  end
end
