require 'rails_values/email_address'

module RailsValues
  RSpec.describe EmailAddress do
    require_relative 'whole_value_role'
    it_behaves_like 'Whole Value' do
      subject { described_class.new('test@mail.com') }
    end

    def cast(*args)
      described_class.cast(*args)
    end

    it 'is equal' do
      first_cast = cast('test@mail.com')
      second_cast = cast('test@mail.com')
      expect(first_cast).to eq(second_cast)
      expect(first_cast).to eql(second_cast)
      expect([first_cast, second_cast].uniq).to have_attributes(size: 1)
    end

    it 'can be created' do
      value = cast('test@mail.com')
      expect(value.to_s).to eq('test@mail.com')
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

    it 'returns exceptional if only local' do
      value = cast('ASFGTGEE')
      expect(value.to_s).to eq('asfgtgee')
      expect(value).not_to be_blank
      expect(value).to be_exceptional

      record = SimpleModel.new
      value.exceptional_errors(record.errors, :email, {})
      expect(record.errors.full_messages).to contain_exactly('Email has a invalid value of asfgtgee')
    end

    it 'returns exceptional if only domain' do
      value = cast('@tes.com')
      expect(value.to_s).to eq('@tes.com')
      expect(value).not_to be_blank
      expect(value).to be_exceptional

      record = SimpleModel.new
      value.exceptional_errors(record.errors, :email, {})
      expect(record.errors.full_messages).to contain_exactly('Email has a invalid value of @tes.com')
    end

    it 'returns exceptional if domain invalid' do
      value = cast('person@4-node-dag')
      expect(value.to_s).to eq('person@4-node-dag')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'returns exceptional if tlds does not exist' do
      value = cast('wesdfcds@wsdx.coc')
      expect(value.to_s).to eq('wesdfcds@wsdx.coc')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'can compare email address' do
      expect(cast('My@mail.com')).to eq(cast('my@mail.com'))
      expect(cast('test1@mail.com')).not_to eq(cast('test2@mail.com'))
    end

    it 'can be converted to json' do
      expect(cast('My@mail.com').as_json).to eq('my@mail.com')
    end
  end
end
