class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :auth_token, :current_user

  def auth_token
    html = (<<-HTML)
      <input type="hidden" name="authenticity_token" value='#{form_authenticity_token}'>
    HTML
    html.html_safe
  end

  def login_user!(user)
    session[:session_token] = user.session_token
  end

  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
end
