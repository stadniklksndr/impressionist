# frozen_string_literal: true

Rails.application.routes.draw do
  resources :articles, :posts, :widgets, :dummy
  get "profiles/[:id]" => "profiles#show"
end
