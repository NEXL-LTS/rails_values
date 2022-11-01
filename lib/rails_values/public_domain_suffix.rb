require 'public_suffix'
require 'multi_json'

require_relative 'whole_value_concern'
require_relative 'exceptional_value'
require_relative 'public_domain_suffix_blank'
require_relative 'country'

module RailsValues
  class PublicDomainSuffix
    include WholeValueConcern
    include Comparable

    # https://data.iana.org/TLD/tlds-alpha-by-domain.txt
    TOP_LEVEL_DOMAINS = File.readlines("#{__dir__}/tlds-alpha-by-domain.txt").map(&:chomp).freeze

    def initialize(content)
      @content = PublicSuffix.parse(content).freeze
      raise ArgumentError, "has invalid tld of #{tld}" unless TOP_LEVEL_DOMAINS.any? { |d| content.upcase.end_with?(d) }

      freeze
    end

    delegate :to_s, :as_json, :hash, :tld, :sld, :trd, to: :content
    delegate :as_json, to: :to_s

    def <=>(other)
      return to_str <=> other.to_s if other.nil?

      to_str <=> other.to_str
    end

    def eql?(other)
      self == other
    end

    def domain
      self.class.cast(content.domain)
    end

    def subdomain
      self.class.cast(content.subdomain)
    end

    def to_str
      to_s
    end

    def to_db
      content&.to_s
    end

    # @return [EmailAddress]
    def local_email(local_part)
      EmailAddress.cast("#{local_part}@#{content}")
    end

    def second_level_domain
      content&.to_s&.split('.')&.first
    end

    FREE_DOMAINS = File.readlines("#{__dir__}/free_email_provider_domains.txt").map(&:chomp).sort.freeze
    def free_email?
      FREE_DOMAINS.bsearch { |x| to_str <=> x }.present?
    end

    TLD_PART_TO_COUNTRY = MultiJson.load(File.read("#{__dir__}/tld_to_country.json")).each_with_object({}) do |i, r|
      tld = i['tld']
      next if i['tld'].blank?

      country = i['country']
      raise "#{country} is not valid" unless Country.is?(country)

      r[tld] = country.freeze
    end.freeze

    def country
      tld_part = tld.split('.').last
      Country.cast(TLD_PART_TO_COUNTRY[".#{tld_part}"])
    end

    def self.cast(content)
      return PublicDomainSuffixBlank.new(content) if content.blank?
      return content if content.is_a?(self)

      domain_text = String(content).downcase.strip
      unless %r{^[^.\s,@?&'/\[\]!\#$%\^*()+=][^\s,@?&'/\[\]!\#$%\^*()+=]*$}.match?(domain_text)
        return ExceptionalValue.new(content)
      end

      return ExceptionalValue.new(content) if [':', '..'].any? { |r| domain_text.include?(r) }

      new(domain_text)
    rescue ::PublicSuffix::Error, ArgumentError => e
      ExceptionalValue.new(content, e.message)
    end

    def self.is?(value)
      cast(value).regular?
    end

    protected

    attr_reader :content
  end
end
