RSpec.describe SimpleStringConverter do
  let(:subject) { described_class.new(EmailAddress) }

  it 'can cast and serialize' do
    value = EmailAddress.cast('my.mail@gmail.com')
    value_serialized = subject.serialize(value)
    value_casted = subject.cast(value_serialized)

    expect(value_serialized).to be_a(String)
    expect(value_casted).to eq(value)
  end
end
