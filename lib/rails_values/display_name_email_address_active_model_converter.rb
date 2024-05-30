require 'sorbet-runtime'
require 'rails_values/display_name_email_address'

module RailsValues
  class DisplayNameEmailAddressActiveModelConverter < ActiveModel::Type::Value
    extend T::Sig

    sig { params(value: T.untyped).returns(T.any(DisplayNameEmailAddress, ExceptionalValue)) }
    def cast(value)
      DisplayNameEmailAddress.cast(value)
    end

    sig { params(value: T.untyped).returns(String) }
    def serialize(value)
      value.format
    end
  end
end
