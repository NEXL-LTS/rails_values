require_relative 'whole_value_concern'
require_relative 'exceptional_value'
require_relative 'blank_subdomain'

module RailsValues
  class Subdomain
    include WholeValueConcern
    include Comparable

    def initialize(content)
      @content = content
      freeze
    end

    delegate :to_s, :to_str, :as_json, to: :content

    def <=>(other)
      to_s <=> other.to_s
    end

    def eql?(other)
      self == other
    end

    def hash
      @content.hash
    end

    # @return [EmailAddress]
    def local_email(local_part)
      EmailAddress.cast("#{local_part}@#{content}")
    end

    def parts
      to_s.split('.')
    end

    def free_email?
      FREE_DOMAINS.bsearch { |x| @content <=> x }.present?
    end

    def student?
      @content.start_with?('student.') || @content.start_with?('students.')
    end

    # https://data.iana.org/TLD/tlds-alpha-by-domain.txt
    TOP_LEVEL_DOMAINS = File.readlines("#{__dir__}/tlds-alpha-by-domain.txt").map(&:chomp).freeze

    FREE_DOMAINS = File.readlines("#{__dir__}/free_email_provider_domains.txt").map(&:chomp).sort.freeze

    def self.free
      FREE_DOMAINS.map { |domain_string| cast(domain_string) }
    end

    def self.cast(content)
      return BlankSubdomain.new if content.blank?
      return content if content.is_a?(Subdomain)

      content = String(content).downcase

      if /^[\w\-#]+([\-.]{1}[\w\-]+)*\.[\w\-]{1,128}$/.match?(content) &&
         TOP_LEVEL_DOMAINS.any? { |tld| content.upcase.end_with?(tld) }
        Subdomain.new(content)
      else
        ExceptionalValue.new(content)
      end
    end

    protected

    attr_reader :content
  end
end
