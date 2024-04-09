require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
  end

  describe 'enums' do
    it 'has the correct enum values' do
      expect(Ticket.statuses.keys).to match_array(['new_unassigned', 'open_assigned', 'in_progress', 'pending', 'resolved', 'closed', 'reopened'])
    end
  end
end
