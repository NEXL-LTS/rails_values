class HTMLContent
  include RailsValues::WholeValueConcern
  include ActionView::Helpers::SanitizeHelper

  def self.cast(content)
    return content if content.is_a?(self)

    content = '' if content.nil?
    new(content)
  end

  def initialize(raw_html)
    @raw_html = raw_html.to_str.clone.freeze
  end

  def ==(other)
    to_s == other.to_s
  end

  def to_s
    sanitize(@raw_html)
  end

  def raw
    @raw_html
  end

  def without_tags
    strip_tags(to_s)
  end

  def +(other)
    HTMLContent.cast(raw + other.raw)
  end

  delegate :include?, to: :to_s
  delegate :blank?, to: :without_tags
end
