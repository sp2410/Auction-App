Rails.application.routes.draw do  
    
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)  
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :payments, only: [:new, :create, :update, :edit]

    resources :users do
      resources :reviews, only: [ :new, :edit, :create, :update, :destroy]
    end


  resources :products do

    
    resources :bills

    resources :pictures

    collection do
      get 'search'      
    end 

     
  	resources :auctions, only: [:create] do 
      resources :counter_offers, only: [:create]
  		resources :bids, only: [:create]
  	end
    
    member do
      put :transfer
      get :acceptbid
      get :putback
      get :acceptcounteroffer
      # get :cancelcounteroffer
    end

    resources :likes, only: [:create]
    
  end
  

  match '/liveauction', to: "products#liveauction", via: :get
  match '/pastauction', to: "products#pastauction", via: :get
  match '/purchases', to: "products#purchases", via: :get
  match '/yourbids', to: "products#yourbids", via: :get

  match '/aboutus', to: "pages#aboutus", via: :get
  match '/guidelines', to: 'pages#guidelines', via: :get
  match '/scams', to: 'pages#scams', via: :get
  match '/safety', to: 'pages#safety', via: :get
  match '/terms', to: 'pages#terms', via: :get
  match '/policy', to: 'pages#policy', via: :get  
  match '/contact', to: 'pages#contact', via: :get 
  match '/blog', to: "pages#blog", via: :get 
  match '/pricing', to: 'pages#pricing', via: :get  
  match '/faq', to: 'pages#faq', via: :get  

  # match '/loaderio-bb065e4eb12e719ea532bd0e37ea9212', to: 'pages#loadtest', via: :get  
  
  
  root 'products#index'
end

