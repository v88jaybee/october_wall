Rails.application.routes.draw do
    get '/'         => 'users#index'
    get 'login'     => 'users#index'

    post 'register' => 'users#register'
    post 'login'    => 'users#authenticate'

    get 'walls'     => 'walls#index'

    get 'logout'    => 'sessions#destroy'

    post 'create_message' => 'walls#create_message'
    post 'create_comment' => 'walls#create_comment'

    post 'delete_message' => 'walls#delete_message'
    post 'delete_comment' => 'walls#delete_comment'
end
