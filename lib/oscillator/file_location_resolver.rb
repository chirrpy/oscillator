module Oscillator
  module FileLocationResolver
    def filename
      "#{mounted_as}.#{file.extension.downcase}" if @filename
    end

    def store_dir
      "#{model.class.name.underscore}/#{model.id}"
    end
  end
end
