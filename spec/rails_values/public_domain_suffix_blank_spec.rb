require 'rails_values/public_domain_suffix'

module RailsValues
  RSpec.describe PublicDomainSuffixBlank do
    require_relative './whole_value_role'
    it_behaves_like 'Whole Value' do
      subject { described_class.new }
    end

    it 'has same API as PublicDomainSuffix' do
      missing_methods = PublicDomainSuffix.cast('nexl.io').public_methods - subject.public_methods
      expect(missing_methods).to be_blank
    end

    it { is_expected.to be_blank }
    it { expect(subject.country).to be_blank }
    it { expect(subject).not_to be_free_email }

    it 'can be sorted in an array with others' do
      countries = [PublicDomainSuffix.cast('testing.com'), subject, PublicDomainSuffix.cast('test.com')].sort

      expect(countries).to eq([subject, PublicDomainSuffix.cast('test.com'), PublicDomainSuffix.cast('testing.com')])
    end

    it 'can be used with uniq' do
      expect([subject, described_class.new].uniq).to contain_exactly(subject)
    end
  end
end
