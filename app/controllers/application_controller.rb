# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user

  private

    def authenticate_user
      @current_user = User.current_user
    end
end
