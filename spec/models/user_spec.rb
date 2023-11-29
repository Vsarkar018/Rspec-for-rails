require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    @user = build(:user)
  end
  describe 'validations' do
    context 'when all attributes are valid' do
      it 'is valid' do
        expect(@user).to be_valid
      end
    end
  #
  #   context 'when name is not present' do
  #     it 'is not valid' do
  #       @user.name = nil
  #       expect(@user).not_to be_valid
  #     end
  #   end
  #
  #   context 'when email is not present' do
  #     it 'is not valid' do
  #       @user.email = nil
  #       expect(@user).not_to be_valid
  #     end
  #   end
  end
end
