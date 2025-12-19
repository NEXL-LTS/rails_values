require_relative 'email_address'

module RailsValues
  class EmailAddressSerializer < ActiveJob::Serializers::ObjectSerializer
    def klass
      EmailAddress
    end

    def serialize?(argument)
      argument.is_a?(klass)
    end

    def serialize(email_address)
      super('value' => email_address.to_str)
    end

    def deserialize(hash)
      EmailAddress.new(hash['value'])
    end
  end
end
