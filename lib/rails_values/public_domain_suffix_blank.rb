require_relative 'blank'

module RailsValues
  class PublicDomainSuffixBlank < Blank
    include Comparable

    def <=>(other)
      to_str <=> other.to_str
    end

    def eql?(other)
      other.blank?
    end

    delegate :hash, to: :to_str

    def free_email?
      false
    end

    def local_email(*)
      EmailAddress.cast('')
    end

    def to_str
      ''
    end

    def tld
      ''
    end

    def sld
      ''
    end

    def trd
      nil
    end

    def domain
      self
    end

    def subdomain
      self
    end

    def country
      Country.cast('')
    end
  end
end
