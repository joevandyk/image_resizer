require 'rails_helper'

describe ResizeImage do
  it 'should work' do
    VCR.use_cassette('fetch image') do
      image = described_class.new(
        version: 'v1',
        option_string: "w_300,h_200,c_fill",
        url: "https://s3.amazonaws.com/tanga-images/d7jdkwcgtnae.jpg"
      )
      expect(image.mime_type).to be == 'image/jpeg'
      expect(image.width).to be  == 300
      expect(image.height).to be ==  200
    end
  end

  it 'should resize png' do
    VCR.use_cassette('fetch png') do
      image = described_class.new(
        version: 'v1',
        option_string: "w_50",
        url: "https://www.google.com/images/srpr/logo11w.png"
      )
      expect(image.mime_type).to be == 'image/png'
      expect(image.width).to be  == 50
      expect(image.height).to be == 18
    end
  end

  it 'should convert BMP to jpg' do
    VCR.use_cassette('fetch bmp') do
      image = described_class.new(
        version: 'v1',
        option_string: "w_300,h_200,c_fill",
        url: "http://ilab.engr.utk.edu/ilabdocs/Epilog/BMP%20sample%20files/horses.bmp"
      )
      expect(image.mime_type).to be == 'image/jpeg'
      expect(image.width).to be  == 300
      expect(image.height).to be ==  200
    end
  end
end
