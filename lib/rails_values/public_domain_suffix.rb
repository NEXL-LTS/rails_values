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

    def <=>(other)
      to_s <=> other.to_s
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

    # @return [EmailAddress]
    def local_email(local_part)
      EmailAddress.cast("#{local_part}@#{content}")
    end

    FREE_DOMAINS = File.readlines("#{__dir__}/free_email_provider_domains.txt").map(&:chomp).sort.freeze
    def free_email?
      FREE_DOMAINS.bsearch { |x| to_str <=> x }.present?
    end

    TLD_TO_COUNTRY = MultiJson.load(File.read("#{__dir__}/tld_to_country.json")).each_with_object({}) do |item,list|
      tld = item['tld']
      next if item['tld'].blank?

      country = item['country']
      raise "#{country} is not valid" unless Country.is?(country)

      list[tld.split('.').last.freeze] = country.freeze
    end.freeze

    def country
      Country.cast(TLD_TO_COUNTRY[tld.split('.').last])
    end

    def self.cast(content)
      return PublicDomainSuffixBlank.new if content.blank?
      return content if content.is_a?(self)

      new(String(content).downcase)
    rescue ::PublicSuffix::Error, ArgumentError => e
      ExceptionalValue.new(content, e.message)
    end

    protected

    attr_reader :content
  end
end
