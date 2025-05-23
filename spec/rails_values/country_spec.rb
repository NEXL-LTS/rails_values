require 'rails_values/country'

module RailsValues
  RSpec.describe Country do
    require 'rails_values/rspec/whole_value_role'
    it_behaves_like 'Whole Value' do
      subject { described_class.cast('AU') }
    end

    it 'can be created by code' do
      country = described_class.cast('TW')
      expect(country.to_s).to eq('TW')
      expect(country.name).to eq('Taiwan')
      expect(country.continent).to eq('Asia')
      expect(country.currency_code).to eq('TWD')
      expect(country.subdivisions).to be_present
      expect(country.subdivision('CHA')).to be_present
      expect(country).to be_present
      expect(country).not_to be_exceptional
    end

    it 'can be created by 3 letter code' do
      country = described_class.cast('USA')
      expect(country.to_s).to eq('US')
      expect(country.name).to eq('United States')
      expect(country.continent).to eq('North America')
      expect(country.currency_code).to eq('USD')
      expect(country.subdivisions).to be_present
      expect(country.subdivision('AK')).to be_present
      expect(country).to be_present
      expect(country).not_to be_exceptional
    end

    it 'can be created by name' do
      country = described_class.cast('Australia')
      expect(country.to_s).to eq('AU')
      expect(country.name).to eq('Australia')
      expect(country).to be_present
      expect(country).not_to be_exceptional
    end

    it 'returns blank' do
      country = described_class.cast('')
      expect(country.to_s).to eq('')
      expect(country).to be_blank
      expect(country).not_to be_exceptional
    end

    it 'returns exceptional' do
      country = described_class.cast('ASFGTGEETSD')
      expect(country.to_s).to eq('ASFGTGEETSD')
      expect(country).not_to be_blank
      expect(country).to be_exceptional
    end

    it 'accepts Tuvalu' do
      country = described_class.cast('Tuvalu')
      expect(country.to_s).to eq('TV')
      expect(country).to be_present
      expect(country).not_to be_exceptional
    end

    it 'accepts Holy See (Vatican City State)' do
      country = described_class.cast('Holy See (Vatican City State)')
      expect(country.to_s).to eq('VA')
      expect(country).to be_present
      expect(country).not_to be_exceptional
      expect(country.name).to eq('Holy See (Vatican City State)')
    end

    it 'accepts "UK" as "GB"' do
      expect(described_class.cast('UK')).to eq(described_class.cast('GB'))
    end

    it 'accepts "England" as "GB"' do
      expect(described_class.cast('England')).to eq(described_class.cast('GB'))
    end

    it 'can compare' do
      expect(described_class.cast('England')).to eq(described_class.cast('England'))
      expect(described_class.cast('England')).not_to eq(described_class.cast('Holy See (Vatican City State)'))
      expect(described_class.cast('England')).not_to eq(described_class.cast(''))
    end
  end
end
