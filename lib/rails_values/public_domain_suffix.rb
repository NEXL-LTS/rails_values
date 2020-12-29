require 'public_suffix'

require_relative 'whole_value_concern'
require_relative 'exceptional_value'
require_relative 'public_domain_suffix_blank'

module RailsValues
  class PublicDomainSuffix
    include WholeValueConcern
    include Comparable

    def initialize(content)
      @content = PublicSuffix.parse(content).freeze
      raise ArgumentError, "has invalid tld of #{tld}" unless TOP_LEVEL_DOMAINS.any?{|d| content.upcase.end_with?(d) }

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

    def free_email?
      self.class.free.include? @content
    end

    # https://data.iana.org/TLD/tlds-alpha-by-domain.txt
    TOP_LEVEL_DOMAINS = File.readlines("#{__dir__}/tlds-alpha-by-domain.txt").map(&:chomp).freeze

    FREE_DOMAINS = File.readlines("#{__dir__}/free_email_provider_domains.txt").map(&:chomp).freeze

    def self.free
      FREE_DOMAINS.map { |domain_string| cast(domain_string) }
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
