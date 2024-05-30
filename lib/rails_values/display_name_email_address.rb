require_relative 'email_address'

module RailsValues
  class DisplayNameEmailAddress < EmailAddress
    include Comparable
    include WholeValueConcern

    delegate :format, to: :mail_address

    def to_s
      if mail_address.display_name
        "#{@mail_address.display_name} <#{@mail_address.address&.downcase}>"
      else
        mail_address.address&.downcase.to_s
      end
    end

    def <=>(other)
      to_s <=> other.to_s
    end

    def self.cast(content)
      return content if content.is_a?(DisplayNameEmailAddress)

      content ||= ''

      DisplayNameEmailAddress.new(content.to_str)
    rescue Mail::Field::ParseError, NoMethodError
      ExceptionalValue.new(content, "has a invalid value of #{content}")
    end
  end
end
