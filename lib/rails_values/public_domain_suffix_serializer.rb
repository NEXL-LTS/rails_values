require_relative 'public_domain_suffix'

module RailsValues
  class PublicDomainSuffixSerializer < ActiveJob::Serializers::ObjectSerializer
    def klass
      PublicDomainSuffix
    end

    def serialize?(argument)
      argument.is_a?(klass)
    end

    def serialize(domain)
      super('value' => domain.to_db)
    end

    def deserialize(hash)
      PublicDomainSuffix.cast(hash['value'])
    end
  end
end
