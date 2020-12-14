require 'countries'
ISO3166.configuration.enable_currency_extension!

class Country
  include RailsValues::WholeValueConcern
  include Comparable

  # @param [ISO3166::Country] country
  def initialize(country)
    @country = country
    freeze
  end

  delegate :as_json, to: :alpha2

  def <=>(other)
    alpha2 <=> other.alpha2
  end

  def eql?(other)
    return false unless other.is_a?(Country)

    alpha2 == other.alpha2
  end

  delegate :hash, to: :alpha2

  def alpha2
    @country.alpha2
  end

  alias code alpha2

  def to_s
    alpha2
  end

  def emoji_flag
    @country.emoji_flag
  end

  def currency
    @country.currency || Money.default_currency
  end

  def currency_code
    currency.try(:iso_code)
  end

  def name
    @country.translations['en']
  end

  def subdivisions
    @country.subdivisions
  end

  def subdivision(subdivision_code)
    return nil if subdivision_code.blank?

    subdivisions.fetch(subdivision_code).tap do |s|
      s.code = subdivision_code
    end
  end

  def continent
    @country.continent
  end

  def self.all
    @all ||= ISO3166::Country.codes.map { |c| cast(c) }.sort_by(&:name).freeze
  end

  def self.indexed_country_by_code
    @indexed_country_by_code ||= {}.tap do |codes|
      all.map { |country| codes[country.alpha2] = country }
    end
  end

  def self.valid_code?(code)
    indexed_country_by_code.key?(code.to_s)
  end

  def self.label_and_values
    all.sort_by(&:name).map { |c| { label: c.name, value: c.alpha2 } }
  end

  def self.subdivision_label_and_values
    @subdivision_label_and_values ||= all.map do |country|
      location_names = country.subdivisions.map { |subinfo| subinfo.last.name }
      { label: country.alpha2, options: location_names.map { |l| { value: l, label: l } } }
    end.freeze
  end

  # @return [Country]
  def self.cast(content)
    return content if content.is_a? self
    return BlankCountry.new if content.blank?

    content = 'GB' if content == 'UK'

    country = ISO3166::Country.send(:[], content) ||
              ISO3166::Country.find_country_by_alpha3(content) ||
              ISO3166::Country.find_country_by_name(content)
    return Country.new(country) if country

    ExceptionalValue.new(content, "has a invalid value of #{content}")
  end

  def self.is?(value)
    cast(value).regular?
  end
end
