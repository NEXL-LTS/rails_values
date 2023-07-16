require 'sorbet-runtime'
require 'rails_values/public_domain_suffix'

module RailsValues
  class PublicDomainSuffixActiveModelConverter < ActiveModel::Type::Value
    extend T::Sig

    sig { params(value: T.untyped).returns(T.any(PublicDomainSuffix, PublicDomainSuffixBlank, ExceptionalValue)) }
    def cast(value)
      PublicDomainSuffix.cast(value)
    end

    sig { params(value: T.untyped).returns(String) }
    def serialize(value)
      value.to_s
    end
  end
end
