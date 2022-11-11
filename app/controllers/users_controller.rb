class UsersController < ApplicationController
    
    before_action do 
        #check if signin
        if signed_in?
            redirect_to "/walls"
        end
    end
    
    def index

    end

    def register
        created_user = User.create_user(register_params)

        if created_user[:status]
            #store session and redirect to wall dashboard
            sign_in created_user[:result]
            redirect_to "/walls"

        else
            flash[:register_errors] = created_user[:message]
            redirect_to "/login"
        end
    end

    def authenticate
        authenticated_user = User.authenticate_user(login_params)

        if authenticated_user[:status]
            #store session and redirect to wall dashboard
            sign_in authenticated_user[:result]
            redirect_to "/walls"
        else
            flash[:login_errors] = authenticated_user[:message]
            redirect_to "/login"
        end
    end

    private
        def register_params
            params.require(:register).permit(:first_name, :last_name, :email_address, :password, :confirm_password)
        end

        def login_params
            params.require(:login).permit(:email_address, :password)
        end
end
