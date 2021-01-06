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
  end
end
