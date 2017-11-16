# frozen_string_literal: true

class ConversationsController < ApplicationController
  def index
    render json: { conversations: @current_user.conversations }
  end

  def create
    conversation = Conversation.create_with_participant_ids(
      conversation_params[:recipients] << @current_user.id
    )
    render json: { conversation: conversation.to_json }, status: :created
  end

  private

    def conversation_params
      params.require(:conversation).permit(
        recipients: []
      )
    end
end
