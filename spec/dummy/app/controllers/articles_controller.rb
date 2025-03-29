# frozen_string_literal: true

class ArticlesController < ApplicationController
  if Rails::VERSION::MAJOR >= 5
    before_action :test_current_user_var
  else
    before_filter :test_current_user_var
  end

  def test_current_user_var
    return unless session[:user_id]

    @current_user = User.new
    @current_user.id = session[:user_id]
  end

  def index
    impressionist(Article.first, "this is a test article impression")
  end

  def show
    impressionist(Article.first)
  end
end
