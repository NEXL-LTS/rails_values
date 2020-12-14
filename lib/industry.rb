require 'csv'

class Industry
  include WholeValueConcern

  LIST = CSV.parse(File.read("#{__dir__}/industry.csv")).freeze

  attr_reader :code, :name

  def initialize(content)
    content = content.to_s
    item = LIST.find { |i| i[0] == content || i[1].casecmp(content).zero? }
    @code = item[0].freeze
    @name = item[1].freeze
    freeze
  end

  include Comparable
  def <=>(other)
    to_s <=> other.to_s
  end

  def eql?(other)
    code == other.code
  end

  delegate :hash, to: :code

  def to_s
    name
  end

  def as_json(options = nil)
    code.as_json(options)
  end

  def inspect
    "#{self.class}(#{code}:#{name})"
  end

  def self.all
    LIST.select { |i| i[0].present? }.map { |i| new(i[0]) }
  end

  def self.cast(content)
    return Blank.new if content.blank?

    case content
    when Integer, String then Industry.new(content)
    when Industry then content
    else ExceptionalValue.new(content, "has a invalid value of #{content}")
    end
  rescue NoMethodError
    ExceptionalValue.new(content, "has a invalid value of #{content}")
  end
end
