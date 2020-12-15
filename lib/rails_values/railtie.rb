require_relative 'email_address_serializer'

ValueValidator = RailsValues::ValueValidator

module RailsValues
  class Railtie < ::Rails::Railtie
    initializer 'rails_values_railtie.configure_rails_initialization' do
      Rails.application.config.active_job.custom_serializers << EmailAddressSerializer
    end
  end
end
