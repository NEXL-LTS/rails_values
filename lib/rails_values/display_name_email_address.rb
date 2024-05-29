require 'mail'
require_relative 'whole_value_concern'
require_relative 'exceptional_value'
require_relative 'subdomain'
require_relative 'public_domain_suffix'
require_relative 'email_address'

module RailsValues
  class DisplayNameEmailAddress < EmailAddress
    include Comparable
    include WholeValueConcern

    delegate :format, to: :mail_address

    def to_s
      if mail_address.display_name
        "#{mail_address.display_name} <#{mail_address.address&.downcase}>"
      else
        mail_address.address&.downcase.to_s
      end
    end

    def <=>(other)
      to_s <=> other.to_s
    end

    def to_str
      complete_address
    end

    def self.cast(content)
      return content if content.is_a?(DisplayNameEmailAddress)

      content ||= ''

      DisplayNameEmailAddress.new(content.to_str)
    rescue Mail::Field::ParseError, NoMethodError
      ExceptionalValue.new(content, "has a invalid value of #{content}")
    end

    private

    def complete_address
      "#{@mail_address.display_name} <#{@mail_address.address&.downcase}>"
      @mail_address.format
    end

  end
end
