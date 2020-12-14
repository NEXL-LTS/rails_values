class Blank
  include WholeValueConcern

  def intitialze
    super
    @blank_string = ''
    freeze
  end

  def to_sym
    nil
  end

  def ==(other)
    other.blank?
  end

  def humanize
    ''
  end

  delegate :blank?, :to_s, :as_json, to: :blank_string

  private

  attr_accessor :blank_string
end
