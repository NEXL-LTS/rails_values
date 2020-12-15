require 'active_support/core_ext/object'

module RailsValues
  module WholeValueConcern
    def regular?
      present? && !exceptional?
    end

    def exceptional?
      false
    end

    def exceptional_errors(_errors, _attribute, _options); end

    delegate :as_json, to: :to_s

    def inspect
      "#{self.class}(#{self})"
    end
  end
end
