# frozen_string_literal: true

class ConversationsController < ApplicationController
  def index
    render json: { conversations: @current_user.conversations }
  end

  def create
    conversation = Conversation.new_with_participant_ids(
      participant_ids_for_create
    )

    if conversation.save
      render json: conversation, status: :created
    else
      render json: { errors: conversation.errors.full_messages }, status: 500
    end
  end

  def show
    conversation = Conversation.find(params[:id])
    render json: conversation, include: :messages
  end

  private

    def participant_ids_for_create
      conversation_params[:recipients] << @current_user.id
    end

    def conversation_params
      params.require(:conversation).permit(
        recipients: []
      )
    end
end
