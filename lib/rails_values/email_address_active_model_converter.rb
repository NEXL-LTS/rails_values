require 'sorbet-runtime'
require 'rails_values/email_address'

module RailsValues
  class EmailAddressActiveModelConverter < ActiveModel::Type::Value
    extend T::Sig

    sig { params(value: T.untyped).returns(T.any(EmailAddress, ExceptionalValue)) }
    def cast(value)
      EmailAddress.cast(value)
    end

    sig { params(value: T.untyped).returns(String) }
    def serialize(value)
      value.to_s
    end
  end
end
