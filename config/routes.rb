ActionController::Routing::Routes.draw do |map|

  map.login "login",        :controller => "user_sessions", :action => "new"
  map.logout "logout",      :controller => "user_sessions", :action => "destroy"
  map.profile "profile",    :controller => "users"        , :action => "edit"
  map.register "register",  :controller => "users"        , :action => "new"

  map.resources :user_sessions
  map.resources :users, :collection => {:mark=>:get,
                                        :showtime=>:get,
                                        :origin=>:get,
                                        :free=>:get,
                                        :distance=>:post}
  map.resources :articles
  map.resources :comments
  map.root      :articles
end
