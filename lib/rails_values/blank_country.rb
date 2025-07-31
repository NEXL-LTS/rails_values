require_relative 'blank'

module RailsValues
  class BlankCountry < Blank
    include Comparable

    def <=>(other)
      to_s <=> other.to_s
    end

    def eql?(other)
      Country.cast(other).is_a?(BlankCountry)
    end

    delegate :hash, to: :alpha2

    def continent
      ''
    end

    def alpha2
      ''
    end

    def code
      ''
    end

    def name
      ''
    end

    def emoji_flag
      ''
    end

    def currency_code
      nil
    end

    def currency
      nil
    end

    def subdivisions
      []
    end

    def subdivision(_)
      nil
    end
  end
end
