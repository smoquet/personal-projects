class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
#dit stopt SessionsHelper bestand in de base class of all controllers, thereby
# making it available for all controllers. de module staat in de helper map
  include SessionsHelper


end
