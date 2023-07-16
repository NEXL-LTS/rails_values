require 'rails_values/country_active_model_converter'

module RailsValues
  RSpec.describe CountryActiveModelConverter do
    subject { described_class.new }

    it 'can cast and serialize regular value' do
      value = Country.cast('ZA')
      expect(value).to be_regular # confirm we have a regular

      value_serialized = subject.serialize(value)
      value_casted = subject.cast(value_serialized)

      expect(value_serialized).to be_a(String)
      expect(value_casted).to eq(value)
    end

    it 'can cast and serialize exceptional value' do
      value = Country.cast('{}')
      expect(value).to be_exceptional # confirm we have a exceptional

      value_serialized = subject.serialize(value)
      value_casted = subject.cast(value_serialized)

      expect(value_serialized).to be_a(String)
      expect(value_casted).to eq(value)
    end

    it 'can cast and serialize blank value' do
      value = Country.cast('')
      expect(value).to be_blank # confirm we have a blank

      value_serialized = subject.serialize(value)
      value_casted = subject.cast(value_serialized)

      expect(value_serialized).to be_a(String)
      expect(value_casted).to eq(value)
    end
  end
end
