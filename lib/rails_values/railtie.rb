require_relative 'email_address_serializer'
require_relative 'http_url_serializer'
require_relative 'public_domain_suffix_serializer'

ValueValidator = RailsValues::ValueValidator

module RailsValues
  class Railtie < ::Rails::Railtie
    initializer 'rails_values_railtie.configure_rails_initialization' do
      Rails.application.config.active_job.custom_serializers << EmailAddressSerializer
      Rails.application.config.active_job.custom_serializers << HttpUrlSerializer
      Rails.application.config.active_job.custom_serializers << PublicDomainSuffixSerializer

      ActiveRecord::Type.register(:rv_country) do
        SimpleStringConverter.new(Country)
      end
      ActiveRecord::Type.register(:rv_email_address) do
        SimpleStringConverter.new(EmailAddress)
      end
      ActiveRecord::Type.register(:rv_subdomain) do
        SimpleStringConverter.new(Subdomain)
      end
      ActiveRecord::Type.register(:rv_public_domain_suffix) do
        SimpleStringConverter.new(PublicDomainSuffix)
      end
      ActiveRecord::Type.register(:rv_http_url) do
        SimpleStringConverter.new(HttpUrl)
      end
    end
  end
end
