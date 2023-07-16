require 'sorbet-runtime'
require 'rails_values/country'

module RailsValues
  class CountryActiveModelConverter < ActiveModel::Type::Value
    extend T::Sig

    sig { params(value: T.untyped).returns(T.any(Country, BlankCountry, ExceptionalValue)) }
    def cast(value)
      Country.cast(value)
    end

    sig { params(value: T.untyped).returns(String) }
    def serialize(value)
      value.to_s
    end
  end
end
