require_relative 'public_domain_suffix'

module RailsValues
  class PublicDomainSuffixSerializer < ActiveJob::Serializers::ObjectSerializer
    def serialize?(argument)
      argument.is_a?(PublicDomainSuffix)
    end

    def serialize(domain)
      super('value' => domain.to_str)
    end

    def deserialize(hash)
      PublicDomainSuffix.cast(hash['value'])
    end
  end
end
