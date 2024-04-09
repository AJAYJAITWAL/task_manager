require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
     let(:user) { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }

    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }

    it 'validates password length' do
      should validate_length_of(:password).is_at_least(6).on(:create)
    end

    context 'when creating a new record' do
      it 'requires a password' do
        user = build(:user, password: nil)
        expect(user).not_to be_valid
      end
    end

    context 'when updating an existing record without changing the password' do
      it 'does not require a password' do
        user = create(:user)
        user.update(username: 'new_username')
        expect(user).to be_valid
      end
    end
  end

  describe 'associations' do
    it { should have_many(:tickets) }
    it { should have_secure_password }
  end

  describe 'enums' do
    it 'has the correct enum values' do
      expect(User.roles).to include('user', 'admin')
    end

    it 'has a default role of user' do
      user = create(:user)
      expect(user.role).to eq('user')
    end
  end
end
