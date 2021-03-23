require 'active_support'
require 'active_model'
require 'action_view'
require 'money-rails'

module RailsValues
  class Error < StandardError; end
end

require_relative 'rails_values/blank'
require_relative 'rails_values/exceptional_value'

require_relative 'rails_values/subdomain'
require_relative 'rails_values/public_domain_suffix'
require_relative 'rails_values/email_address'
require_relative 'rails_values/email_address_list'
require_relative 'rails_values/http_url'
require_relative 'rails_values/html_content'
require_relative 'rails_values/country'
require_relative 'rails_values/industry'
require_relative 'rails_values/industry_list'
require_relative 'rails_values/currency_casting'

require_relative 'rails_values/simple_string_converter'
require_relative 'rails_values/simple_json_converter'

require_relative 'rails_values/value_validator'

require_relative 'rails_values/railtie' if defined?(Rails) && defined?(Rails::Railtie)
