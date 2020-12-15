require 'rails_values/subdomain'

module RailsValues
  RSpec.describe BlankSubdomain do
    require_relative './whole_value_role'
    it_behaves_like 'Whole Value' do
      subject { described_class.new }
    end

    it 'has same API as Subdomain' do
      missing_methods = Subdomain.cast('nexl.io').public_methods - subject.public_methods
      expect(missing_methods).to be_blank
    end

    it { is_expected.to be_blank }

    it 'can be sorted in an array with other countries' do
      countries = [Subdomain.cast('us.com'), subject, Subdomain.cast('au.com')].sort

      expect(countries).to eq([subject, Subdomain.cast('au.com'), Subdomain.cast('us.com')])
    end

    it 'can be used with uniq' do
      expect([subject, described_class.new].uniq).to contain_exactly(subject)
    end
  end
end
