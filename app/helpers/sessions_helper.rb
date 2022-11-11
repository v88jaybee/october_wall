module SessionsHelper
    def sign_in(user)
        session[:user_id] = user["id"]
    end

    def signout
        session[:user_id] = nil
    end
end
