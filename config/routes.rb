ActionController::Routing::Routes.draw do |map|
  map.resources :feeds, :collection => {:load => :get, :preview => :get }
  map.root :controller => :feeds
end
