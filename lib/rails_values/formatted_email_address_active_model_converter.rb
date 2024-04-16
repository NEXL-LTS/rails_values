require 'sorbet-runtime'
require 'rails_values/email_address'

module RailsValues
  class FormattedEmailAddressActiveModelConverter < ActiveModel::Type::Value
    extend T::Sig

    sig { params(value: T.untyped).returns(T.any(EmailAddress, ExceptionalValue)) }
    def cast(value)
      EmailAddress.cast(value)
    end

    sig { params(value: T.untyped).returns(String) }
    def serialize(value)
      value.format
    end
  end
end
