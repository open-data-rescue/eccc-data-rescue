
class PageImageUploader < ImageUploader
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
 
    { 
      thumb:  magick.resize_to_limit!(64, 64),
      small:  magick.resize_to_limit!(200, 200),
      medium: magick.resize_to_limit!(400, 400),
      xlarge: magick.resize_to_limit!(1000, 1000),
      original: magick
    }
  end

  Attacher.default_url do |derivative: nil, **|
    file&.url if derivative
  end
end
