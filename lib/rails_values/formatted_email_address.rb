require 'mail'
require_relative 'whole_value_concern'
require_relative 'exceptional_value'
require_relative 'subdomain'
require_relative 'public_domain_suffix'

module RailsValues
  class FormattedEmailAddress < EmailAddress
    include Comparable
    include WholeValueConcern

    def to_s
      @mail_address.format.to_s
    end

    def to_str
      @mail_address.format.to_s
    end

    def self.cast(content)
      return content if content.is_a?(FormattedEmailAddress)

      content ||= ''

      FormattedEmailAddress.new(content.to_str)
    rescue Mail::Field::ParseError, NoMethodError
      ExceptionalValue.new(content, "has a invalid value of #{content}")
    end

  end
end
