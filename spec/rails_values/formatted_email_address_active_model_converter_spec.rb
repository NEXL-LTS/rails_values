require 'rails_values/formatted_email_address_active_model_converter'

module RailsValues
  RSpec.describe FormattedEmailAddressActiveModelConverter do
    subject { described_class.new }

    it 'can cast and serialize regular value' do
      value = EmailAddress.cast('My Email <my.mail@gmail.com>')
      expect(value).to be_regular

      value_serialized = subject.serialize(value)
      value_casted = subject.cast(value_serialized)
      expect(value_serialized).to be_a(String)
      expect(value_casted).to eq(value)
    end

    it 'can retain display name and email in serialized value' do
      value = EmailAddress.cast('My Email <my.mail@gmail.com>')
      value_serialized = subject.serialize(value)
      expect(value_serialized).to eq 'My Email <my.mail@gmail.com>'
    end

    it 'can cast and serialize exceptional value' do
      value = EmailAddress.cast('my.mail@localhost')
      expect(value).to be_exceptional # confirm we have a exceptional

      value_serialized = subject.serialize(value)
      value_casted = subject.cast(value_serialized)

      expect(value_serialized).to be_a(String)
      expect(value_casted).to eq(value)
    end

    it 'can cast and serialize blank value' do
      value = EmailAddress.cast('')
      expect(value).to be_blank

      value_serialized = subject.serialize(value)
      value_casted = subject.cast(value_serialized)

      expect(value_serialized).to be_a(String)
      expect(value_casted).to eq(value)
    end
  end
end
