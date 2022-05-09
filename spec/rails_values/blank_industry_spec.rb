require 'rails_values/industry'

module RailsValues
  RSpec.describe BlankIndustry do
    require 'rails_values/rspec/whole_value_role'
    it_behaves_like 'Whole Value' do
      subject { described_class.new }
    end

    it 'has same API' do
      missing_methods = Industry.cast('101010').public_methods - subject.public_methods
      expect(missing_methods).to be_blank
    end

    it { is_expected.to be_blank }

    it 'can be sorted in an array with other industries' do
      countries = [Industry.cast('101010'), subject, Industry.cast('201010')].sort

      expect(countries).to eq([subject, Industry.cast('201010'), Industry.cast('101010')])
    end

    it 'can be used with uniq' do
      expect([subject, described_class.new].uniq).to contain_exactly(subject)
    end
  end
end
