class UsersController < ApplicationController
  # this means that the logged_in_user fucntion defined here will always
  # call before edit and update and index acions
  before_action :logged_in_user,  only: [:edit, :update, :index, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy


  def index
    @users = User.paginate(page: params[:page])
  end


  def new
    # here we create a new user to use in the signup page
    @user = User.new
  end

  def show
    #params[:id] gets the id of the user from the User controller.
    # for example: "1". Tht find method returns the corresponding user
  @user = User.find(params[:id])
  # debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      # redirects you to new users page
      # synonym: redirect_to user_url(@user)
      redirect_back_or @user
    else
      # if creation fails, you go back to creating a new user
      render 'new'
    end
  end


  def edit
    # the parameters are submitted in the corresponding view
    @user = User.find(params[:id])
  end

def update
  @user = User.find(params[:id])
  if @user.update_attributes(user_params)
    flash[:succes] = 'Profile updated'
    redirect_to @user
  else
    render 'edit'
  end
end

def destroy
  User.find(params[:id]).destroy
  flash[:success] = "User deleted"
  redirect_to users_url
end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # before filters (are called automatically before certain actions)

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = 'Please log in.'
        redirect_to login_url
      end
    end

    # Confirms the correct user. and if not the current user redirects him to root
    def correct_user
      @user = User.find(params[:id])
      #this code uses the self written current_user? method form the helper file in sessions helper
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
