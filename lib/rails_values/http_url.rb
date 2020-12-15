require_relative 'whole_value_concern'

module RailsValues
  class HttpUrl
    include Comparable
    include WholeValueConcern

    attr_reader :url

    def initialize(input_value)
      @url = URI.parse(input_value.to_s.strip).freeze
      freeze
    end

    def <=>(other)
      to_s <=> other.to_s
    end

    def eql?(other)
      self == other
    end

    delegate :hash, to: :to_s

    def exceptional?
      present? && !(url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS))
    end

    def exceptional_errors(errors, attribute, _options = nil)
      errors[attribute] << "has a invalid value of #{self}" if exceptional?
    end

    delegate :blank?, to: :to_s

    delegate :to_s, to: :url
    delegate :path, :query, :request_uri, to: :url

    def to_str
      url.to_s
    end

    def inspect
      "#{self.class}(#{self})"
    end

    def self.cast(value)
      return value if value.is_a?(self)

      new(value)
    rescue URI::InvalidURIError => e
      ExceptionalValue.new(e.message)
    end
  end
end
