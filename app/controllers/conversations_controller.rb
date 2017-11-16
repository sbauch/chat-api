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
    page = params[:page] || 1
    messages = conversation.messages.page(page)

    render json: conversation,
        include: :messages,
           page: page,
           meta: pagination_dict(messages)
  end

  private

    def pagination_dict(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count
      }
    end

    def participant_ids_for_create
      conversation_params[:recipients] << @current_user.id
    end

    def conversation_params
      params.require(:conversation).permit(
        recipients: []
      )
    end
end
