class SessionsController < ApplicationController
  def new
  end

  def create
    # vind de user
    user = User.find_by(email: params[:session][:email].downcase)
    # als de user er is en wachtwoord goed, dan
    if user && user.authenticate(params[:session][:password])
    # log in User
      log_in user
      # this calls upon fucntion in helper file
      params[:session][:remember_me] == '1' ?  remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    #only logout if logged in (for mulitple window logout twice error)
    log_out if logged_in?
    redirect_to root_url
  end

end
