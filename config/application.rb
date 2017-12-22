require_relative 'boot'

require 'rails/all'

require File.expand_path('../../lib/auction_socket', __FILE__)

require File.expand_path('../../lib/emailnotifier', __FILE__)

require File.expand_path('../../lib/twilionotifier', __FILE__)



# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tutsauction
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Central Time (US & Canada)'

    config.sass.preferred_syntax = :sass

    config.middleware.use AuctionSocket
    
    # config.autoload_paths += %W(#{config.root}/lib)
    
    config.autoload_paths << Rails.root.join('lib')
    
  end
end
