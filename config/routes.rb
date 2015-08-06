Rails.application.routes.draw do
  get ':version/:options/*url' => 'image#show', constraints: { url: /.*/ }
end
