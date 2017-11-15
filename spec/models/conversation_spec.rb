require 'rails_helper'

RSpec.describe Conversation, type: :model do
  
  describe "::create_with_participants" do
    
    context "provided >1 participant" do
      
      xit "creates a conversation" do
        allow(described_class).to receive(:create).with(:credit_card).and_return
        described_class.create_with_participants
        
      end
      
      
    end
    
  end
  
end
