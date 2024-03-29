require 'rails_values/value_validator'
require 'rails_values/email_address'

module RailsValues
  RSpec.describe ValueValidator do
    let(:validator) { described_class.new({ attributes: [:test] }) }

    it do
      expect do
        validator.validate_each(SimpleModel.new, :test, EmailAddress.cast('test'))
      end.not_to raise_error
    end
  end
end
