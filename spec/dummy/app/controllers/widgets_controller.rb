# frozen_string_literal: true

class WidgetsController < ApplicationController
  impressionist actions: %i[show index], unique: %i[controller_name action_name impressionable_id params]

  def show; end

  def index; end

  def new; end
end
