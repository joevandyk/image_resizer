require 'rails_helper'

RSpec.describe "Images", type: :request do
  describe "GET" do
    it "works" do
      VCR.use_cassette('request spec') do
        get '/v2/w_250,h_600/https%3A%2F%2Fs3.amazonaws.com%2Ftanga-images%2Fd7jdkwcgtnae.jpg'
        expect(response).to have_http_status(200)
        image = MiniMagick::Image.read(response.body)
        expect(image.mime_type).to be == 'image/jpeg'
        expect(image.width).to be == 250
      end
    end
  end
end
