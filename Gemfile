source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'


# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'


# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# gem "jquery-ui-rails"
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'spring',        group: :development

gem "haml-rails"

gem "autoprefixer-rails"
gem "devise"
gem "faye-websocket"
gem "pry"
gem "hirb"
gem 'kaminari'
gem 'bootstrap_form'

gem 'carrierwave', '~> 0.10.0'
gem 'mini_magick', '~> 4.3'

gem 'geocoder'
gem 'activeadmin', github: 'activeadmin'
# gem 'paypal-sdk-rest'
gem 'social-share-button', github: "huacnlee/social-share-button"

#payments
gem 'activemerchant'

#Text Notification
gem 'twilio-ruby', '~> 4.11.1'

#email notifications
gem 'sendgrid-ruby'

#edumund API
gem 'httparty'

#gem 'rmagick', '~> 2.3.0'

# gem 'braintree'


#beautiful alerts
gem 'slide-down-alerts-rails'
#gem 'sprockets-rails', :require => 'sprockets/railtie'
gem "fog"

gem 'figaro'


group :test do
  gem "database_cleaner"
  gem "timecop"
  gem "pry-byebug"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]



group :development do 
	# Use sqlite3 as the database for Active Record
	gem 'sqlite3'

	
end

group :production do 	
	gem 'pg'
	gem 'rails_12factor'
	gem 'heroku-deflater'
	#new relic monitoring
	# gem 'newrelic_rpm'
	# gem "skylight"

end