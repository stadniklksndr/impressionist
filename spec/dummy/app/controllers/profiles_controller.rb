# frozen_string_literal: true

class ProfilesController < ApplicationController
  helper_method :current_user

  def show; end

  def current_user
    return unless session[:user_id]

    user = User.new
    user.id = session[:user_id]
    @current_user ||= user
  end
end
