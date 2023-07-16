ValueValidator = RailsValues::ValueValidator

module RailsValues
  class Railtie < ::Rails::Railtie
    initializer 'rails_values_railtie.configure_rails_initialization' do
      require_relative 'email_address_serializer'
      Rails.application.config.active_job.custom_serializers << EmailAddressSerializer

      require_relative 'http_url_serializer'
      Rails.application.config.active_job.custom_serializers << HttpUrlSerializer

      require_relative 'public_domain_suffix_serializer'
      Rails.application.config.active_job.custom_serializers << PublicDomainSuffixSerializer

      ActiveRecord::Type.register(:rv_subdomain) { SimpleStringConverter.new(Subdomain) }
      require_relative 'country_active_model_converter'
      ActiveRecord::Type.register(:rv_country) { CountryActiveModelConverter }
      require_relative 'email_address_active_model_converter'
      ActiveRecord::Type.register(:rv_email_address) { EmailAddressActiveModelConverter }
      require_relative 'public_domain_suffix_active_model_converter'
      ActiveRecord::Type.register(:rv_public_domain_suffix) { PublicDomainSuffixActiveModelConverter }
      require_relative 'http_url_active_model_converter'
      ActiveRecord::Type.register(:rv_http_url) { HttpUrlActiveModelConverter }
      require_relative 'currency_casting'
      ActiveRecord::Type.register(:rv_currency) { CurrencyCasting }
    end
  end
end
