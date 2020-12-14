class ValueValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value.exceptional_errors(record.errors, attribute, options)
  end
end
