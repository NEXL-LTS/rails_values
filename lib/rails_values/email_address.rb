require 'mail'
require_relative 'whole_value_concern'
require_relative 'exceptional_value'
require_relative 'subdomain'
require_relative 'public_domain_suffix'

module RailsValues
  class EmailAddress
    include Comparable
    include WholeValueConcern

    def initialize(address)
      @mail_address = Mail::Address.new(address)
      freeze
    end

    delegate :local, :display_name, to: :mail_address

    delegate :as_json, to: :to_s

    def <=>(other)
      to_s <=> other.to_s.downcase
    end

    def eql?(other)
      self == other
    end

    delegate :hash, to: :to_s

    def exceptional?
      (present? && domain.blank?) || subdomain.exceptional? || domain.exceptional?
    end

    def exceptional_errors(errors, attribute, _options = nil)
      errors.add(attribute, "has a invalid value of #{self}") if exceptional?
    end

    delegate :blank?, to: :to_s

    def to_s
      mail_address.address&.downcase.to_s
    end

    def to_str
      mail_address.address.to_s
    end

    delegate :domain, to: :mail_address, prefix: true

    def domain
      return subdomain unless subdomain.regular?

      subdomain.domain
    end

    def subdomain
      PublicDomainSuffix.cast(mail_address_domain)
    end

    def subdomain?
      domain != subdomain
    end

    def another_with_same_domain(local:)
      subdomain.local_email(local)
    end

    def free_email?
      !exceptional? &&
        (subdomain.free_email? || to_s.match?(/\A\w\d+@telstra\.com\z/))
    end

    def inspect
      "#{self.class}(#{mail_address.format})"
    end

    # @return [EmailAddress,ExceptionalValue]
    def self.cast(content)
      return content if content.is_a?(EmailAddress)

      content ||= ''

      EmailAddress.new(content.to_str)
    rescue Mail::Field::ParseError, NoMethodError
      ExceptionalValue.new(content, "has a invalid value of #{content}")
    end

    def self.same?(val1, val2)
      cast(val1) == cast(val2)
    end

    # @return [EmailAddress]
    def self.cast!(value)
      cast(value).tap do |email|
        raise "email is blank: #{value.inspect}" if email.blank?
        raise "#{email.reason}: #{value.inspect}" if email.exceptional?
      end
    end

    def self.is?(value)
      cast(value).regular?
    end

    private

    attr_reader :mail_address
  end
end
