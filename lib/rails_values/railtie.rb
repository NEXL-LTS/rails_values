require_relative 'email_address_serializer'

ValueValidator = RailsValues::ValueValidator

module RailsValues
  class Railtie < ::Rails::Railtie
    initializer 'rails_values_railtie.configure_rails_initialization' do
      Rails.application.config.active_job.custom_serializers << EmailAddressSerializer
      ActiveRecord::Type.register(:rv_country) do
        SimpleStringConverter.new(Country)
      end
      ActiveRecord::Type.register(:rv_email_address) do
        SimpleStringConverter.new(EmailAddress)
      end
      ActiveRecord::Type.register(:rv_subdomain) do
        SimpleStringConverter.new(Subdomain)
      end
    end
  end
end
