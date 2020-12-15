require 'active_support/core_ext/object'

module RailsValues
  class ExceptionalValue
    attr_reader :reason

    def initialize(raw_value, reason = "has a invalid value of #{raw_value}")
      @raw_value = raw_value
      @reason = reason
    end

    def ==(other)
      other.to_s == @raw_value.to_s
    end

    def to_s
      @raw_value.to_s
    end

    def to_str
      @raw_value.to_str
    end

    def to_sym
      return nil unless @raw_value

      @raw_value.to_sym
    end

    def inspect
      "#{self.class}(#{self})"
    end

    def exceptional?
      true
    end

    def regular?
      false
    end

    delegate :blank?, :as_json, to: :to_s

    def exceptional_errors(errors, attribute, _options = nil)
      errors[attribute] << @reason
    end
  end
end
