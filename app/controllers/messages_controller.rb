# frozen_string_literal: true

class MessagesController < ApplicationController
  def create
    message = Message.new_in_conversation(
      create_params[:conversation_id],
      @current_user,
      create_params[:content]
    )

    if message.save
      #TODO: broadcast this message to other participants
      render json: { message: message }, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: 500
    end
  end

  private

    def create_params
      params.require(:message).permit(
        :content,
        :conversation_id
      )
    end
end
