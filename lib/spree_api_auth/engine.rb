module SpreeApiAuth
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_api_auth'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Spree::Api::Config[:requires_authentication] = false
      Spree::Api::ApiHelpers.user_attributes << :spree_api_key
    end

    config.to_prepare &method(:activate).to_proc
  end
end
