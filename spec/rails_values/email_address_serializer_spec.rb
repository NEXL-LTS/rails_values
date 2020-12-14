require 'active_job/arguments'

module RailsValues
  RSpec.describe EmailAddressSerializer do
    subject { described_class.instance }

    it 'can cast and serialize' do
      value = EmailAddress.cast('person@mail.com')
      value_serialized = subject.serialize(value)
      value_casted = subject.deserialize(value_serialized)

      expect(value_serialized).to be_a(Hash)
      expect(value_casted).to eq(value)
    end
  end
end
