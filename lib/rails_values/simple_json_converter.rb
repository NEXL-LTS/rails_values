module RailsValues
  class SimpleJsonConverter < ActiveModel::Type::Value
    def initialize(type_class)
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
