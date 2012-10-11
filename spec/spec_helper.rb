require 'active_model'
require 'action_view'
require 'carrierwave'
require 'oscillator'

Dir[File.expand_path('../support/**/*.rb',   __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.after(:suite) do
    `rm -rf ./my_model`
  end
end
