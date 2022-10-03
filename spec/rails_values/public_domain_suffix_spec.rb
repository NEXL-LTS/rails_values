require 'rails_values/public_domain_suffix'

module RailsValues
  RSpec.describe PublicDomainSuffix do
    require 'rails_values/rspec/whole_value_role'
    it_behaves_like 'Whole Value' do
      subject { described_class.new('mail.com') }
    end

    def cast(*args)
      PublicDomainSuffix.cast(*args)
    end

    it 'can be created' do
      value = cast('mail.com')
      expect(value.to_s).to eq('mail.com')
      expect(value).to be_present
      expect(value).not_to be_exceptional
    end

    it 'can be created with long root domain' do
      value = cast('adams.africa')
      expect(value.to_s).to eq('adams.africa')
      expect(value).to be_present
      expect(value).not_to be_exceptional
    end

    it 'accepts longer root domain' do
      value = cast('test.americanexpress')
      expect(value.to_s).to eq('test.americanexpress')
      expect(value).to be_present
      expect(value).not_to be_exceptional
    end

    it 'accepts nexl.com.au' do
      value = cast('nexl.com.au')
      expect(value.to_s).to eq('nexl.com.au')
      expect(value).to be_present
      expect(value).not_to be_exceptional
    end

    it 'accepts numbers and dashes' do
      value = cast('xn--85x722f.xn--55qx5d.cn')
      expect(value.to_s).to eq('xn--85x722f.xn--55qx5d.cn')
      expect(value).to be_present
      expect(value).not_to be_exceptional
    end

    it 'accepts underscores' do
      value = cast('under_score.com')
      expect(value.to_s).to eq('under_score.com')
      expect(value).to be_present
      expect(value).not_to be_exceptional
    end

    it 'accepts other printable characters' do
      value = cast('oñí.com')
      expect(value.to_s).to eq('oñí.com')
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

    it 'returns exceptional if top level domain' do
      value = cast('org')
      expect(value.to_s).to eq('org')
      expect(value).not_to be_blank
      expect(value).to be_exceptional

      record = SimpleModel.new
      value.exceptional_errors(record.errors, :public_domain_suffix, {})
      expect(record.errors.full_messages)
        .to contain_exactly('Public domain suffix `org` is not allowed according to Registry policy')
    end

    it 'returns exceptional if invalid top level domain' do
      value = cast('wsdx.coc')
      expect(value.to_s).to eq('wsdx.coc')
      expect(value).not_to be_blank
      expect(value).to be_exceptional

      record = SimpleModel.new
      value.exceptional_errors(record.errors, :public_domain_suffix, {})
      expect(record.errors.full_messages)
        .to contain_exactly('Public domain suffix has invalid tld of coc')
    end

    it 'returns exceptional if starts with "."' do
      value = cast('.tes.com')
      expect(value.to_s).to eq('.tes.com')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
      val_nil = nil
      expect(value == val_nil).to be_falsy
    end

    it 'returns exceptional if includes spaces' do
      value = cast('subastar .com.co')
      expect(value.to_s).to eq('subastar .com.co')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'returns exceptional if includes commas' do
      value = cast('macan.com,sg')
      expect(value.to_s).to eq('macan.com,sg')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'returns exceptional if starts with "@"' do
      value = cast('@subastar.com.co')
      expect(value.to_s).to eq('@subastar.com.co')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'returns exceptional if contains "@"' do
      value = cast('person@subastar.com.co')
      expect(value.to_s).to eq('person@subastar.com.co')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'returns exceptional if starts with "?"' do
      value = cast('?subastar.com.co')
      expect(value.to_s).to eq('?subastar.com.co')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'returns exceptional if contains "&"' do
      value = cast('allen&overy.com')
      expect(value.to_s).to eq('allen&overy.com')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'returns exceptional if contains "\'"' do
      value = cast('have\'younot.com')
      expect(value.to_s).to eq('have\'younot.com')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'returns exceptional if contains "/"' do
      value = cast('aaa/calif.com')
      expect(value.to_s).to eq('aaa/calif.com')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'returns exceptional if contains invalid characters' do
      value = cast('s[u]bastar.com.co')
      expect(value.to_s).to eq('s[u]bastar.com.co')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'returns exceptional if contains https' do
      value = cast('https:frontier.com')
      expect(value.to_s).to eq('https:frontier.com')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'returns exceptional if contains ..' do
      value = cast('aristocrat.com..\..\..\..\..\..\..\..\..\..\..\..\..\..\..\..\winnt\win.ini')
      expect(value.to_s).to eq('aristocrat.com..\..\..\..\..\..\..\..\..\..\..\..\..\..\..\..\winnt\win.ini')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
    end

    it 'can compare' do
      expect(cast('mail.com')).to eq(cast('mail.com'))
      expect(cast('mail.com')).to eq(cast('MAIL.com'))
      expect(cast('other.com')).not_to eq(cast('mail.com'))
    end

    describe '#free_email?' do
      it { expect(cast('gmail.com')).to be_free_email }
      it { expect(cast('me.com')).to be_free_email }
      it { expect(cast('privaterelay.appleid.com')).to be_free_email }

      it { expect(cast('nexl.io')).not_to be_free_email }
    end

    describe '#country' do
      it { expect(cast('example.co.za').country).to eq(Country.cast('ZA')) }
      it { expect(cast('www.lawyers.af').country).to eq(Country.cast('AF')) }
      it { expect(cast('nexl.com.au').country).to eq(Country.cast('AU')) }
      it { expect(cast('app.nexl.io').country).to eq(Country.cast('')) }
      it { expect(cast('nexl.org').country).to eq(Country.cast('')) }
      it { expect(cast('example.com').country).to eq(Country.cast('')) }
      it { expect(cast('example.co').country).to eq(Country.cast('')) }
    end
  end
end
