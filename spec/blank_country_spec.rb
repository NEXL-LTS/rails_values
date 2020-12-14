RSpec.describe BlankCountry do
  require_relative './whole_value_role'
  it_behaves_like 'Whole Value' do
    subject { described_class.new }
  end

  it 'has same API as country' do
    missing_methods = Country.cast('AU').public_methods - subject.public_methods
    expect(missing_methods).to be_blank
  end

  it { is_expected.to be_blank }

  it 'can be sorted in an array with other countries' do
    countries = [Country.cast('US'), subject, Country.cast('AU')].sort

    expect(countries).to eq([subject, Country.cast('AU'), Country.cast('US')])
  end

  it 'can be used with uniq' do
    expect([subject, described_class.new].uniq).to contain_exactly(subject)
  end
end
