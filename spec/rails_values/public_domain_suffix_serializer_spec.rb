require 'active_job'
require 'active_job/arguments'
require 'rails_values/public_domain_suffix_serializer'

module RailsValues
  RSpec.describe PublicDomainSuffixSerializer do
    subject { described_class.instance }

    it 'can cast and serialize' do
      value = PublicDomainSuffix.cast('mail.com')
      value_serialized = subject.serialize(value)
      value_casted = subject.deserialize(value_serialized)

      expect(value_serialized).to be_a(Hash)
      expect(value_casted).to eq(value)
    end

    it 'serializes nil as nil' do
      value = PublicDomainSuffix.cast(nil)
      value_serialized = subject.serialize(value)
      expect(value_serialized["value"]).to be_nil
    end

    it 'serializes empty string as empty string' do
      value = PublicDomainSuffix.cast('')
      value_serialized = subject.serialize(value)
      expect(value_serialized["value"]).to eq('')
    end
  end
end
