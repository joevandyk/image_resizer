class ResizeImage
  attr_reader :version, :options, :url
  delegate :mime_type, to: :image
  def initialize(version:, options:, url:)
    @version = version
    @options = Options.new(options)
    @url     = url
  end

  def file_path
    image.path
  end

  def image
    @image ||=
      MiniMagick::Image.open(url).tap do |image|
      image.combine_options do |b|
        b << options.commands
      end
    end
  end
end

class ResizeImage::Options
  def initialize(option_string)
    @option_string = option_string
  end

  def resize_string
    "#{width}x#{height}"
  end

  def commands
    commands = []
    return commands unless should_process?
    if should_crop?
      size = resize_string + '^'
      # Note: ordering is important.
      commands << '-background' << 'none'
      commands << '-thumbnail' << size
      commands << '-gravity' << gravity
      commands << '-extent'  << size
    elsif should_scale?
      commands << "-thumbnail" << resize_string
    end
    commands << "-quality" << "75"
  end

  def width
    match(/w_(\d+)/)
  end

  def height
    match(/h_(\d+)/)
  end

  def crop
    match(/c_(\w+)/)
  end

  def gravity
    gravity = match(/g_(\w+)/)
    valid_gravities.include?(gravity) ? gravity : 'center'
  end

  private

  def should_crop?
    crop == 'fill'
  end

  def should_scale?
    width.present? || height.present?
  end

  def should_process?
    should_crop? || should_scale?
  end

  def valid_gravities
    %w( none center east forget northeast north northwest southeast south southwest west)
  end

  def match(regex)
    @option_string[regex, 1]
  end
end
