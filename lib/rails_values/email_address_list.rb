require 'multi_json'
require_relative 'whole_value_concern'
require_relative 'email_address'

module RailsValues
  class EmailAddressList
    include WholeValueConcern
    include Enumerable

    def self.cast(content)
      return content if content.is_a?(EmailAddressList)

      content = MultiJson.load(content) if content.is_a?(String)
      new(content)
    end

    def initialize(emails)
      casted_emails = Array.wrap(emails).select(&:present?).map { |email| EmailAddress.cast(email) }
      @list = casted_emails.uniq.sort_by(&:to_s).freeze
      freeze
    end

    def only_regular
      self.class.cast(regular_list)
    end

    def to_s
      @list.map(&:to_s).join(' ')
    end

    def blank?
      @list.blank?
    end

    def exceptional?
      @list.any?(&:exceptional?)
    end

    def exceptional_errors(errors, attribute, _options = nil)
      @list.select(&:exceptional?).each do |invalid_email|
        errors.add(attribute, invalid_email.reason)
      end
    end

    def ==(other)
      to_s == other.to_s
    end

    def as_json(*options)
      @list.as_json(*options)
    end

    def each(only_regular: true, &block)
      if only_regular
        regular_list.each(&block)
      else
        @list.each(&:block)
      end
    end

    def size(only_regular: true)
      only_regular ? regular_list.size : @list.size
    end

    def include?(value)
      value = EmailAddress.cast(value)
      !@list.bsearch { |x| value <=> x }.nil?
    end

    private

    def regular_list
      @list.select(&:regular?)
    end
  end
end
