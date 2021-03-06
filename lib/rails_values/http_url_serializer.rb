require_relative 'http_url'

module RailsValues
  class HttpUrlSerializer < ActiveJob::Serializers::ObjectSerializer
    def serialize?(argument)
      argument.is_a?(HttpUrl)
    end

    def serialize(value)
      super('value' => value.to_str)
    end

    def deserialize(hash)
      HttpUrl.new(hash['value'])
    end
  end
end
