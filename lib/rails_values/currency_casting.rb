require 'sorbet-runtime'
require 'money'

module RailsValues
  class CurrencyCasting < ActiveModel::Type::Value
    extend T::Sig

    def self.cast(value)
      new.cast(value)
    end

    sig { params(value: T.untyped).returns(T.nilable(Money::Currency)) }
    def cast(value)
      if value.is_a? Money::Currency
        value
      else
        Money::Currency.find(value)
      end
    end

    sig { params(value: T.untyped).returns(T.nilable(String)) }
    def serialize(value)
      if value.is_a? Money::Currency
        value.iso_code
      else
        Money::Currency.find(value)&.iso_code
      end
    end
  end
end
