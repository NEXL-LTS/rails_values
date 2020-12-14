require 'multi_json'

class IndustryList
  def self.cast(content)
    return content if content.is_a?(IndustryList)

    content = MultiJson.load(content) if content.is_a?(String)
    new(content)
  end

  include WholeValueConcern
  def initialize(industries)
    casted = Array.wrap(industries).select(&:present?).map { |i| Industry.cast(i) }
    @list = casted.uniq.sort_by(&:to_s).freeze
    freeze
  end

  include Enumerable
  def each(&block)
    @list.each(&block)
  end

  def to_s
    map(&:to_s).map { |s| "\"#{s}\"" }.join(' ')
  end

  def empty?
    @list.empty?
  end

  def blank?
    @list.blank?
  end

  def exceptional?
    any?(&:exceptional?)
  end

  def exceptional_errors(errors, attribute, _options = nil)
    select(&:exceptional?).each do |invalid_value|
      errors[attribute] << invalid_value.reason
    end
  end

  def ==(other)
    to_s == other.to_s
  end

  def as_json(*options)
    @list.as_json(*options)
  end

  def +(other)
    IndustryList.new(@list + other.to_a)
  end
end
