module SessionsHelper
  # deze functie stopt de id van de user op dat moment (user.id) in
  # een variabele session[:user_id] die kan worden opgehaald op andere paginas

  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    #this calls a method in the user class (user.rb)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # returns true if given user is current_user
  def current_user?(user)
    user == current_user
  end

# returns the user correspondng to the remember token cookie
  def current_user
    # als er een user is in de current session, neem die dan als current user.
    # !!!!! en assign hem ook meteen aan user_id (het is geen ==)
    if (user_id = session[:user_id])
    # als de current user er al is, zoek dan niet verder. Als ie er niet is, roep dan find_by aan
      @current_user ||= User.find_by(id: user_id)
    # als er geen user is in de current session, kijk dan in de cookie
    # !!!! en assign het aan user_id, het is geen ==
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
    #if it comes here, it retunrs nil
  end

  def logged_in?
    #this means: not current_user = nil
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


# this fnction logs out a user, by deleting it in the session and resetting the
# current user to nil
# this function is called upon in the sessions_controller.rb file
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

# redirects to stored location or default
def redirect_back_or(default)
  redirect_to(session[:forwarding_url] || default)
  session.delete(:forwarding_url)
end

# stores the url trying to be accessed
def store_location
  session[:forwarding_url] = request.url if request.get?
end



end
