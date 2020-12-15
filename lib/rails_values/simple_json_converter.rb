module RailsValues
  class SimpleJsonConverter < ActiveModel::Type::Value
    def initialize(type_class)
      raise ArgumentError, "#{type_class} does not respond to cast" unless type_class.respond_to?(:cast)

      @type_class = type_class
      super()
    end

    def cast(value)
      @type_class.cast(value)
    end

    def serialize(value)
      value.as_json.to_json
    end
  end
end
