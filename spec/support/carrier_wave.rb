###
# Makes CarrierWave tests faster and more reliable
#

CarrierWave.configure do |config|
  config.storage           = :file
  config.enable_processing = false
end

RSpec.configure do |config|
  config.before(:each, :carrier_wave => true) do
    @test_image_directory = File.dirname(__FILE__) + '/../fixtures/'
  end
end
