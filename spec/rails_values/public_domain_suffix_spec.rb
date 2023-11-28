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

    it 'is equal' do
      first_cast = cast('mail.com')
      second_cast = cast('mail.com')
      expect(first_cast).to eq(second_cast)
      expect(first_cast).to eql(second_cast)
      expect([first_cast, second_cast].uniq).to have_attributes(size: 1)
      expect(first_cast).to eq('mail.com')
    end

    it 'can be created with long root domain' do
      value = cast('adams.africa')
      expect(value.to_s).to eq('adams.africa')
      expect(value).to be_present
      expect(value).not_to be_exceptional
      expect(value.tld).to eq('africa')
      expect(value.sld).to eq('adams')
      expect(value.trd).to be_nil
    end

    it 'accepts longer root domain' do
      value = cast('test.americanexpress')
      expect(value.to_s).to eq('test.americanexpress')
      expect(value).to be_present
      expect(value).not_to be_exceptional
      expect(value.tld).to eq('americanexpress')
      expect(value.sld).to eq('test')
      expect(value.trd).to be_nil
    end

    it 'accepts nexl.com.au' do
      value = cast('nexl.com.au')
      expect(value.to_s).to eq('nexl.com.au')
      expect(value).to be_present
      expect(value).not_to be_exceptional
      expect(value.tld).to eq('com.au')
      expect(value.sld).to eq('nexl')
      expect(value.trd).to be_nil
    end

    it 'accepts eu.nexl.cloud' do
      value = cast('eu.nexl.cloud')
      expect(value.to_s).to eq('eu.nexl.cloud')
      expect(value).to be_present
      expect(value).not_to be_exceptional
      expect(value.domain).to eq('nexl.cloud')
      expect(value.subdomain).to eq('eu.nexl.cloud')
      expect(value.tld).to eq('cloud')
      expect(value.sld).to eq('nexl')
      expect(value.trd).to eq('eu')
    end

    it 'accepts gov.uk' do
      value = cast('gov.uk')
      expect(value.to_s).to eq('gov.uk')
      expect(value).to be_present
      expect(value).not_to be_exceptional
      expect(value.domain).to eq('gov.uk')
      expect(value.subdomain).to eq('gov.uk')
      expect(value.tld).to eq('gov.uk')
      expect(value.sld).to be_nil
      expect(value.trd).to be_nil
    end

    it 'accepts mil.no' do
      value = cast('mil.no')
      expect(value.to_s).to eq('mil.no')
      expect(value).to be_present
      expect(value).not_to be_exceptional
      expect(value.domain).to eq('mil.no')
      expect(value.subdomain).to eq('mil.no')
      expect(value.tld).to eq('mil.no')
      expect(value.sld).to be_nil
      expect(value.trd).to be_nil
    end

    it 'accepts mil.local' do
      value = cast('mil.local')
      expect(value.to_s).to eq('mil.local')
      expect(value).to be_present
      expect(value).not_to be_exceptional
      expect(value.domain).to eq('mil.local')
      expect(value.subdomain).to eq('mil.local')
      expect(value.tld).to eq('local')
      expect(value.sld).to eq('mil')
      expect(value.trd).to be_nil
    end

    it 'accepts numbers and dashes' do
      value = cast('xn--85x722f.xn--55qx5d.cn')
      expect(value.to_s).to eq('xn--85x722f.xn--55qx5d.cn')
      expect(value).to be_present
      expect(value).not_to be_exceptional
      expect(value.tld).to eq('cn')
      expect(value.sld).to eq('xn--55qx5d')
      expect(value.trd).to eq('xn--85x722f')
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
        .to contain_exactly('Public domain suffix has invalid tld')
    end

    it 'returns exceptional if invalid tld' do
      value = cast('test.comn')
      expect(value.to_s).to eq('test.comn')
      expect(value).not_to be_blank
      expect(value).to be_exceptional
      val_nil = nil
      expect(value == val_nil).to be_falsy
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
      it { expect(cast('gmail.com.au')).to be_free_email }
      it { expect(cast('gmail.co')).to be_free_email }
      it { expect(cast('gmail.net.au')).to be_free_email }
      it { expect(cast('83gmail.com')).to be_free_email }
      it { expect(cast('outlook.com.au')).to be_free_email }
      it { expect(cast('outlook.co')).to be_free_email }
      it { expect(cast('outlook.net.au')).to be_free_email }
      it { expect(cast('yahoo.com.au')).to be_free_email }
      it { expect(cast('yahoo.co')).to be_free_email }
      it { expect(cast('yahoo.net.au')).to be_free_email }
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

    describe '#client_level_domain' do
      it {
        value = cast('nexl.com.au')
        expect(value.client_level_domain).to eq('nexl')

        value = cast('dentons.rodik.com.au')
        expect(value.client_level_domain).to eq('dentons.rodik')

        value = cast('dentons.rodik.fr')
        expect(value.client_level_domain).to eq('dentons.rodik')

        value = cast('nexl.com')
        expect(value.client_level_domain).to eq('nexl')

        value = cast('')
        expect(value.client_level_domain).to eq('')
      }
    end
  end
end
