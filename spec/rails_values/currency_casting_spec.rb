require 'rails_values'

module RailsValues
  RSpec.describe CurrencyCasting do
    describe '#cast' do
      context 'with valid currency' do
        it{
          expect(described_class.new.cast('USD')).to be_present
          expect(described_class.new.cast('USD')).to eq(Money::Currency.find('USD')) 
        }
      end

      context 'with invalid currency' do
        it{
          expect(described_class.new.cast('XYZ')).to be_blank
        }
      end
    end

    it '#serialize' do
      expect(described_class.new.serialize(Money::Currency.find('USD'))).to eq('USD')
    end
  end
end
