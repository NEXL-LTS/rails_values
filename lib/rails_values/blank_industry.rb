require_relative 'blank'

module RailsValues
  class BlankIndustry < Blank
    include Comparable
    def <=>(other)
      to_s <=> other.to_s
    end

    def eql?(other)
      code == other.code
    end

    delegate :hash, to: :code

    def code
      ''
    end

    def name
      ''
    end
  end
end
