require 'rails_values/simple_json_converter'
require 'rails_values/email_address_list'

module RailsValues
  RSpec.describe SimpleJsonConverter do
    subject { described_class.new(EmailAddressList) }

    it 'can cast and serialize' do
      value = EmailAddressList.cast(%w[one@email.com two@mail.io])
      value_serialized = subject.serialize(value)
      value_casted = subject.cast(value_serialized)

      expect(value_serialized).to be_a(String)
      expect(value_casted).to eq(value)
    end
  end
end
