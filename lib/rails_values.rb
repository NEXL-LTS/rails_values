require 'active_support/core_ext'
require 'active_model'
require 'action_view'

module RailsValues
  class Error < StandardError; end
end

# require_relative 'whole_value_concern'
# require_relative 'blank'
# require_relative 'exceptional_value'

# require_relative 'subdomain'
# require_relative 'blank_subdomain'
# require_relative 'email_address'
# require_relative 'email_address_list'
# require_relative 'http_url'
# require_relative 'html_content'
# require_relative 'country'
# require_relative 'blank_country'
# require_relative 'industry'
# require_relative 'industry_list'

# require_relative 'simple_string_converter'
# require_relative 'simple_json_converter'

# require_relative 'value_validator'

require_relative 'rails_values/railtie' if defined?(Rails) && defined?(Rails::Railtie)
