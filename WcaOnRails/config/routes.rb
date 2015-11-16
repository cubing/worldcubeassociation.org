Rails.application.routes.draw do
  use_doorkeeper

  # Prevent account deletion.
  #  https://github.com/plataformatec/devise/wiki/How-To:-Disable-user-from-destroying-their-account
  devise_for :users, skip: :registrations
  devise_scope :user do
    resource :registration,
      only: [:new, :create],
      path: 'users',
      path_names: { new: 'sign_up' },
      controller: 'accounts/registrations',
      as: :user_registration do
        get :cancel
      end
  end
  resources :users, only: [:index, :edit, :update]
  get 'users/edit' => 'users#edit'
  get 'users/:id/edit/avatar_thumbnail' => 'users#edit_avatar_thumbnail', as: :users_avatar_thumbnail_edit
  get 'users/:id/edit/pending_avatar_thumbnail' => 'users#edit_pending_avatar_thumbnail', as: :users_pending_avatar_thumbnail_edit
  namespace :users do
    resources :avatars, only: [:index]
  end
  post 'users/avatars' => 'users/avatars#update_all'

  resources :competitions, only: [:index, :edit, :update, :new, :create] do
    patch 'registrations/all' => 'registrations#update_all', as: :registrations_update_all
    resources :registrations, only: [:index, :update] do
    end
  end
  get 'competitions/:id/edit/admin' => 'competitions#admin_edit', as: :admin_edit_competition
  get 'competitions/:id/edit/nearby_competitions' => 'competitions#nearby_competitions', as: :nearby_competitions

  # TODO - these are vulnerable to CSRF. We should be able to change these to
  # POSTs once check_comp_data.php has been ported to Rails.
  # See https://github.com/cubing/worldcubeassociation.org/issues/161
  get 'competitions/:id/post/announcement' => 'competitions#post_announcement', as: :competition_post_announcement
  get 'competitions/:id/post/results' => 'competitions#post_results', as: :competition_post_results

  get 'delegate' => 'delegates_panel#index'
  get 'delegate/crash-course' => 'delegates_panel#crash_course'
  get 'delegate/crash-course/edit' => 'delegates_panel#edit_crash_course'
  patch 'delegate/crash-course' => 'delegates_panel#update_crash_course'
  resources :notifications, only: [:index]

  root 'posts#index'
  resources :posts
  get 'rss' => 'posts#rss'

  get 'robots' => 'static_pages#robots'

  get 'about' => 'static_pages#about'
  get 'delegates' => 'static_pages#delegates'
  get 'organisations' => 'static_pages#organisations'
  get 'contact' => 'static_pages#contact'
  get 'score-tools' => 'static_pages#score_tools'
  get 'logo' => 'static_pages#logo'
  get 'wca-workbook-assistant' => 'static_pages#wca_workbook_assistant'
  get 'wca-workbook-assistant-versions' => 'static_pages#wca_workbook_assistant_versions'

  get 'contact/wrc' => 'contacts#wrc'
  post 'contact/wrc' => 'contacts#wrc_create'

  get 'contact/website' => 'contacts#website'
  post 'contact/website' => 'contacts#website_create'

  get "/regulations" => 'regulations#show', id: "index"
  get "/regulations/*id" => 'regulations#show'

  namespace :api do
    get '/', to: redirect('/api/v0')
    namespace :v0 do
      get '/' => "api#help"
      get '/me' => "api#me"
      get '/auth/results' => "api#auth_results"
      get '/scramble-program' => "api#scramble_program"
      get '/users/search' => 'api#users_search'
      get '/users/delegates/search' => 'api#users_delegates_search'
      get '/users/:id' => 'api#show_user_by_id', constraints: { id: /\d+/ }
      get '/users/:wca_id' => 'api#show_user_by_wca_id'
      resources :competitions, only: [:show]
    end
  end
end
