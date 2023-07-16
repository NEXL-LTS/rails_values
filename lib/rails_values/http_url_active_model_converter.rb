require 'sorbet-runtime'
require 'rails_values/http_url'

module RailsValues
  class HttpUrlActiveModelConverter < ActiveModel::Type::Value
    extend T::Sig

    sig { params(value: T.untyped).returns(T.any(HttpUrl, ExceptionalValue)) }
    def cast(value)
      HttpUrl.cast(value)
    end

    sig { params(value: T.untyped).returns(String) }
    def serialize(value)
      value.to_s
    end
  end
end
