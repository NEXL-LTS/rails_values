require 'rails_values/display_name_email_address'

module RailsValues
  RSpec.describe DisplayNameEmailAddress do
    require 'rails_values/rspec/whole_value_role'
    it_behaves_like 'Whole Value' do
      subject { described_class.new('Test <test@mail.com>') }
    end

    def cast(*args)
      described_class.cast(*args)
    end

    it 'to_s should lower case the email address' do
      expect(cast('Test <TEST@mail.com>')).to eq('Test <test@mail.com>')
    end

    it 'they are equal if display names and emails are the same' do
      first_cast = cast('Test <test@mail.com>')
      second_cast = cast('Test <test@mail.com>')
      expect(first_cast).to eq(second_cast)
      expect(first_cast).to eql(second_cast)
      expect([first_cast, second_cast].uniq).to have_attributes(size: 1)
      expect(first_cast).to eq('Test <test@mail.com>')
    end

    it 'they are not equal if there is any difference in display name' do
      first_cast = cast('Test <test@mail.com>')
      second_cast = cast('Marketing <test@mail.com>')
      third_cast = cast('TEST <test@mail.com>')
      expect(first_cast).not_to eq(second_cast)
      expect(first_cast).not_to eql(second_cast)
      expect(first_cast).not_to eq(third_cast)
      expect(first_cast).not_to eql(third_cast)
    end

    it 'can be created' do
      value = cast('Test <test@mail.com>')
      expect(value.to_s).to eq('Test <test@mail.com>')
      expect(value).to be_present
      expect(value).to be_free_email
      expect(value).not_to be_exceptional
    end

    it 'can be created with privaterelay.appleid.com' do
      value = cast('test@privaterelay.appleid.com')
      expect(value.to_s).to eq('test@privaterelay.appleid.com')
      expect(value).to be_present
      expect(value).to be_free_email
      expect(value).not_to be_exceptional
    end

    it 'can be created with marbrathen@mil.no' do
      value = cast('marbrathen@mil.no')
      expect(value.to_s).to eq('marbrathen@mil.no')
      expect(value).to be_present
      expect(value).not_to be_free_email
      expect(value).not_to be_exceptional
    end

    it 'can handle blank' do
      value = cast('')
      expect(value.to_s).to eq('')
      expect(value).to be_blank
      expect(value).not_to be_free_email
      expect(value).not_to be_exceptional
    end

    it 'can handle nil' do
      value = cast(nil)
      expect(value.to_s).to eq('')
      expect(value).to be_blank
      expect(value).not_to be_free_email
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
      expect(value).not_to be_free_email
    end

    it 'returns exceptional if domain with double ..' do
      value = cast('saljubis01@yahoo.com..my')
      expect(value.to_s).to eq('saljubis01@yahoo.com..my')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
      expect(value.domain).to be_exceptional
      expect(value).not_to be_free_email
    end

    it 'returns exceptional if tlds does not exist' do
      value = cast('wesdfcds@wsdx.coc')
      expect(value.to_s).to eq('wesdfcds@wsdx.coc')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'can compare email address' do
      expect(cast('My Email <my@mail.com>')).to eq(cast('My Email <my@mail.com>'))
      expect(cast('test1@mail.com')).not_to eq(cast('test2@mail.com'))
    end

    it 'can be converted to json' do
      expect(cast('Reply <my@mail.com>').as_json).to eq('Reply <my@mail.com>')
    end

    it 'can return the entire email' do
      expect(cast('Display Name <sender@nexl.io>').format).to eq('Display Name <sender@nexl.io>')
    end

    describe '#free_email?' do
      it { expect(cast('My@mail.com')).to be_free_email }
      it { expect(cast('person.email@telstra.com')).not_to be_free_email }
      it { expect(cast('c732841@telstra.com')).to be_free_email }
    end
  end
end
