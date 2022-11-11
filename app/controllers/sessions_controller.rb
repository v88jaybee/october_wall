class SessionsController < ApplicationController
    def destroy
        signout
        redirect_to '/'
    end
end
