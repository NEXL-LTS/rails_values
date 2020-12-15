require 'rails_values/http_url'

module RailsValues
  RSpec.describe HttpUrl do
    require_relative 'whole_value_role'
    it_behaves_like 'Whole Value' do
      subject { described_class.new('http://www.example.com') }
    end

    def cast(*args)
      described_class.cast(*args)
    end

    it 'is equal' do
      first_cast = cast('http://www.example.com/page')
      second_cast = cast('http://www.example.com/page')
      expect(first_cast).to eq(second_cast)
      expect(first_cast).to eql(second_cast)
      expect([first_cast, second_cast].uniq).to have_attributes(size: 1)
    end

    it 'can be created' do
      value = cast('http://www.example.com/page')
      expect(value.to_s).to eq('http://www.example.com/page')
      expect(value).to be_present
      expect(value).not_to be_exceptional
    end

    it 'can be created with https' do
      value = cast('https://www.example.com/page')
      expect(value.to_s).to eq('https://www.example.com/page')
      expect(value).to be_present
      expect(value).not_to be_exceptional
    end

    it 'can handle blank' do
      value = cast('')
      expect(value.to_s).to eq('')
      expect(value).to be_blank
      expect(value).not_to be_exceptional
    end

    it 'can handle nil' do
      value = cast(nil)
      expect(value.to_s).to eq('')
      expect(value).to be_blank
      expect(value).not_to be_exceptional
    end

    it 'returns exceptional if only path' do
      value = cast('/my_network')
      expect(value.to_s).to eq('/my_network')
      expect(value).not_to be_blank
      expect(value).to be_exceptional

      record = SimpleModel.new
      value.exceptional_errors(record.errors, :email, {})
      expect(record.errors.full_messages)
        .to contain_exactly('Email has a invalid value of /my_network')
    end

    it 'returns exceptional if wrong protocol' do
      value = cast('ftp://other')
      expect(value.to_s).to eq('ftp://other/')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'can compare' do
      expect(cast('http://app.nexl.io/other')).to eq(cast('http://app.nexl.io/other'))
      expect(cast('http://app.nexl.io/mine')).not_to eq(cast('http://app.nexl.io/other'))
    end

    it 'can be converted to json' do
      expect(cast('http://app.nexl.io/other').as_json).to eq('http://app.nexl.io/other')
    end
  end
end
