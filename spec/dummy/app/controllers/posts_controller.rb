# frozen_string_literal: true

class PostsController < ApplicationController
  helper_method :current_user

  impressionist

  def index; end

  def show; end

  def edit; end

  def current_user
    return unless session[:user_id]

    user = User.new
    user.id = session[:user_id]
    @current_user ||= user
  end
end
