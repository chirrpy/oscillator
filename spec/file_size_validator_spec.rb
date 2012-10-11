require 'spec_helper'

class ImageUploader < CarrierWave::Uploader::Base
end

class ValidatableClassWithMinimum
  include ActiveModel::Validations
  extend  CarrierWave::Mount

  attr_accessor   :image

  mount_uploader  :image

  validates       :image,
                    :'oscillator/file_size' => {
                      minimum:    2 }
end

class ValidatableClassWithMaximum
  include ActiveModel::Validations
  extend  CarrierWave::Mount

  attr_accessor   :image

  mount_uploader  :image

  validates       :image,
                    :'oscillator/file_size' => {
                      maximum:    2 }
end

class ValidatableClassWithWithin
  include ActiveModel::Validations
  extend  CarrierWave::Mount

  attr_accessor   :image

  mount_uploader  :image

  validates       :image,
                    :'oscillator/file_size' => {
                      within:    2..4 }
end

class ValidatableClassWithIs
  include ActiveModel::Validations
  extend  CarrierWave::Mount

  attr_accessor   :image

  mount_uploader  :image

  validates       :image,
                    :'oscillator/file_size' => {
                      is:       2 }
end

describe Oscillator::FileSizeValidator, :carrier_wave do
  describe '#valid?' do
    context 'when a `minimum` is set' do
      let(:validatable) { ValidatableClassWithMinimum.new }

      context 'and a file lower than the minimum is stored' do
        before { validatable.image.store! File.open(@test_image_directory + '0-byte-file.txt') }

        it 'is false' do
          validatable.should_not be_valid
        end
      end

      context 'and a file the same as the minimum is stored' do
        before { validatable.image.store! File.open(@test_image_directory + '2-byte-file.txt') }

        it 'is true' do
          validatable.should be_valid
        end
      end
    end

    context 'when a `maximum` is set' do
      let(:validatable) { ValidatableClassWithMaximum.new }

      context 'and a file higher than the maximum is stored' do
        before { validatable.image.store! File.open(@test_image_directory + '3-byte-file.txt') }

        it 'is false' do
          validatable.should_not be_valid
        end
      end

      context 'and a file the same as the maximum is stored' do
        before { validatable.image.store! File.open(@test_image_directory + '2-byte-file.txt') }

        it 'is true' do
          validatable.should be_valid
        end
      end
    end

    context 'when a `within` range is set' do
      let(:validatable) { ValidatableClassWithWithin.new }

      context 'and a file below the bottom of the range is stored' do
        before { validatable.image.store! File.open(@test_image_directory + '0-byte-file.txt') }

        it 'is false' do
          validatable.should_not be_valid
        end
      end

      context 'and a file at the bottom of the range is stored' do
        before { validatable.image.store! File.open(@test_image_directory + '2-byte-file.txt') }

        it 'is true' do
          validatable.should be_valid
        end
      end

      context 'and a file at the top of the range is stored' do
        before { validatable.image.store! File.open(@test_image_directory + '4-byte-file.txt') }

        it 'is true' do
          validatable.should be_valid
        end
      end

      context 'and a file above the top of the range is stored' do
        before { validatable.image.store! File.open(@test_image_directory + '5-byte-file.txt') }

        it 'is false' do
          validatable.should_not be_valid
        end
      end
    end

    context 'when `is` is set' do
      let(:validatable) { ValidatableClassWithIs.new }

      context 'and a file below the bottom of the range is stored' do
        before { validatable.image.store! File.open(@test_image_directory + '0-byte-file.txt') }

        it 'is false' do
          validatable.should_not be_valid
        end
      end

      context 'and a file that is the exact size is stored' do
        before { validatable.image.store! File.open(@test_image_directory + '2-byte-file.txt') }

        it 'is true' do
          validatable.should be_valid
        end
      end

      context 'and a file above the top of the range is stored' do
        before { validatable.image.store! File.open(@test_image_directory + '3-byte-file.txt') }

        it 'is false' do
          validatable.should_not be_valid
        end
      end
    end
  end
end
