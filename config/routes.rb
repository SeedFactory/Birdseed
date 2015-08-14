Rails.application.routes.draw do
  get '/faq' => 'static#faq'
  get '/about' => 'static#about'
  get '/talk_to_us' => 'static#talk_to_us'
  mount Spree::Core::Engine, :at => '/'
end
