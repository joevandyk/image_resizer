class ImageController < ApplicationController
  # /v2/w_600,h_600/https%3A%2F%2Fs3.amazonaws.com%2Ftanga-images%2Fjxbn83mcyp92.png
  def show
    image = ResizeImage.new(version:        params[:version],
                            option_string:  params[:options],
                            url:            params[:url])

    send_file(image.path, disposition: 'inline', type: image.mime_type)
  end
end
