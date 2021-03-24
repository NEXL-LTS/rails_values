require 'rails_values/currency_casting'

module RailsValues
  RSpec.describe CurrencyCasting do
    describe '#cast' do
      context 'with valid currency string' do
        it { expect(described_class.new.cast('USD')).to eq(Money::Currency.find('USD')) }
      end

      context 'with valid currency object' do
        money = Money::Currency.find('USD')
        it { expect(described_class.new.cast(money)).to eq(money) }
      end

      context 'with invalid currency' do
        it { expect(described_class.new.cast('XYZ')).to be_blank }
      end
    end

    it '#serialize' do
      expect(described_class.new.serialize(Money::Currency.find('USD'))).to eq('USD')
    end
  end
end
