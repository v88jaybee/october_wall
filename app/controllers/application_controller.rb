class ApplicationController < ActionController::Base
    include SessionsHelper

    def signed_in?
        # check if session user_id and current_user are set 
        current_user.present? && session[:user_id].present?
    end

    private
        def current_user
            if session[:user_id]
                @current_user ||= User.fetch_user_by_id(session[:user_id])
            end
        end
end
