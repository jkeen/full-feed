ActionController::Routing::Routes.draw do |map|
  # map.resources :feeds, :collection => {:load => :get, :preview => :get }

  map.load_feeds '/load.:format', {:action => :load, :controller => :feeds}
  map.preview_feeds '/preview.:format', {:action => :preview, :controller => :feeds}
  
  map.root :controller => :feeds
end
