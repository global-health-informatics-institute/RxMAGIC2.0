class UsersController < ApplicationController
    def new
    end

    def create
    end

    def edit
    end

    def update
    end

    def delete
    end

    def destroy
    end

    def new_user_role
    end

    def create_user_role
        user = User.create(user_params)
        if user.errors.blank?
            flash[:success] = "User profile successfully created"
            redirect_to "/"
        else
            flash[:errors] = user.errors
            redirect_to "/new_user_role"
        end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :user_role, :username)
    end
end
