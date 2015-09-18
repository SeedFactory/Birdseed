Rails.application.routes.draw do

  get '/faq' => 'static#faq'
  get '/about' => 'static#about'
  get '/talk_to_us' => 'static#talk_to_us'

  get '/shop' => 'shop#index'
  get '/shop/birds(/:bird)' => 'shop#birds', as: :shop_birds
  get '/shop/brands(/:brand)' => 'shop#brands', as: :shop_brands
  get '/shop/search' => 'shop#search'

  patch '/checkout/:state' => 'spree/checkout#update', :as => :update_checkout

  get '/orders' => 'orders#index'

  get '/login' => 'login#new', as: :login
  post '/login' => 'login#create'

  mount Spree::Core::Engine, :at => '/'

end
