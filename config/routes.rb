Rails.application.routes.draw do
  # /v2/w_600,h_600/https%3A%2F%2Fs3.amazonaws.com%2Ftanga-images%2Fjxbn83mcyp92.png
  get ':version/:options/*url' => 'image#show', constraints: { url: /.*/ }
end
