require 'spec_helper'

class ResolvableUploader < CarrierWave::Uploader::Base
  include Oscillator::FileLocationResolver
end

class MyModel
  def id
    123
  end
end

describe Oscillator::FileLocationResolver, :carrier_wave do
  let(:model)    { MyModel.new                             }
  let(:uploader) { ResolvableUploader.new model, :resolver }

  describe '#filename' do
    context 'when a file has been stored' do
      before { uploader.store! File.open(@test_image_directory + 'SMALL-LOGO-SHORT-AND-WIDE.PNG') }

      it 'is the mounted as name along with the lowercase file extension' do
        uploader.filename.should eql 'resolver.png'
      end
    end

    context 'when a file has not been stored' do
      it 'is nil' do
        uploader.filename.should be_nil
      end
    end
  end

  describe '#store_dir' do
    it 'is the underscored class name followed by a subfolder for the ID of the model' do
      uploader.store_dir.should eql 'my_model/123'
    end
  end
end
