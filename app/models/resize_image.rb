# TODO:
#  - store resizes on S3 (prob md5 of version/option/url)
#  - Log resizes to database
#  - Check resizes in database before fetching them
#     - if they exist, then serve the thumbnail from s3 instead
#  - Benchmark to see if fetching from s3 is faster
class ResizeImage
  attr_reader :version, :options, :url
  delegate :path, :mime_type, :width, :height, to: :image

  def initialize(version:, option_string:, url:)
    @version        = version
    @option_string  = option_string
    @url            = url
  end

  def image
    #return MiniMagick::Image.open("https://tanga-image-resizer-nginx.herokuapp.com/v2/w_300,h_300/http%3A%2F%2Filab.engr.utk.edu%2Filabdocs%2FEpilog%2FBMP%2520sample%2520files%2Fhorses.bmp")

    @image ||=
      minimagick_image.tap do |image|
        image.format options.format
        image.combine_options do |mogrify|
          options.commands.each do |command|
            mogrify << command
          end
        end
      end
  end

  private

  def options
    @options ||= Options.new(image: minimagick_image, option_string: @option_string)
  end

  def minimagick_image
    @mini ||= MiniMagick::Image.open(url)
  end
end

class ResizeImage::Options
  def initialize(option_string:, image:)
    @option_string = option_string
    @image = image
  end

  # Returns a list of imagemagick commands based on the option string.
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

  def format
    case @image.mime_type
    when 'image/png', 'image/gif'
      'png'
    else
      'jpg'
    end
  end

  private

  def resize_string
    "#{width}x#{height}"
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
