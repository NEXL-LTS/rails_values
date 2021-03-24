require 'money'

module RailsValues
  class CurrencyCasting < ActiveModel::Type::Value
    def self.cast(value)
      new.cast(value)
    end

    def cast(value)
      if value.is_a? Money::Currency
        value
      else
        Money::Currency.find(value)
      end
    end

    def serialize(value)
      if value.is_a? Money::Currency
        value.iso_code
      else
        Money::Currency.find(value)&.iso_code
      end
    end
  end
end
