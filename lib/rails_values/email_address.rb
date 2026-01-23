require 'mail'
require_relative 'whole_value_concern'
require_relative 'exceptional_value'
require_relative 'subdomain'
require_relative 'public_domain_suffix'

module RailsValues
  class EmailAddress
    include Comparable
    include WholeValueConcern

    def initialize(address, original_input: nil)
      @mail_address = Mail::Address.new(address)
      @original_input = original_input
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
      (present? && domain.blank?) || subdomain.exceptional? || domain.exceptional? || local_has_space?
    end

    def exceptional_errors(errors, attribute, _options = nil)
      errors.add(attribute, "has a invalid value of #{self}") if exceptional?
    end

    delegate :blank?, to: :to_s

    def to_s
      return @original_input.to_s.downcase if @original_input

      address = mail_address.address&.downcase.to_s
      remove_local_quotes(address)
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
        (subdomain.free_email? || to_s.match?(/\A\w\d+@telstra\.com\z/) || to_s.match?(/\A.+@rogers\.com\z/))
    end

    def inspect
      "#{self.class}(#{mail_address.format})"
    end

    # @return [EmailAddress,ExceptionalValue]
    def self.cast(content)
      return content if content.is_a?(EmailAddress)

      content ||= ''
      content_str = content.to_str

      EmailAddress.new(content_str)
    rescue Mail::Field::ParseError, Mail::Field::IncompleteParseError, NoMethodError
      handle_parse_error(content_str)
    end

    def self.handle_parse_error(content_str)
      if content_str.include?('@') && content_str.include?(' ')
        domain_part = content_str.split('@').last
        normalized = "placeholder@#{domain_part}"
        EmailAddress.new(normalized, original_input: content_str)
      else
        ExceptionalValue.new(content_str, "has a invalid value of #{content_str}")
      end
    end
    private_class_method :handle_parse_error

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

    def local_has_space?
      return @original_input.to_s.split('@').first.include?(' ') if @original_input

      local_part = local.to_s
      unquoted_local = local_part.gsub(/\A"|"\z/, '')
      unquoted_local.include?(' ')
    end

    def remove_local_quotes(address)
      return address unless address.include?('"')

      address.gsub(/^"([^"]+)"@/, '\1@')
    end
  end
end
