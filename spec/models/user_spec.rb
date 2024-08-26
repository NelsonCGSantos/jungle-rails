require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).to be_valid
    end

    it 'is not valid without a first name' do
      user = User.new(
        first_name: nil,
        last_name: 'Doe',
        email: 'john.doe@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("First name can't be blank")
    end

    it 'is not valid without a last name' do
      user = User.new(
        first_name: 'John',
        last_name: nil,
        email: 'john.doe@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Last name can't be blank")
    end

    it 'is not valid without an email' do
      user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: nil,
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Email can't be blank")
    end

    it 'is not valid if email is not unique (case insensitive)' do
      User.create!(
        first_name: 'Jane',
        last_name: 'Doe',
        email: 'test@domain.com',
        password: 'password',
        password_confirmation: 'password'
      )
      user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'TEST@DOMAIN.COM',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include('Email has already been taken')
    end

    it 'is not valid without a matching password confirmation' do
      user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        password: 'password',
        password_confirmation: 'different'
      )
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'is not valid if the password is too short' do
      user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        password: '123',
        password_confirmation: '123'
      )
      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
    end
  end

  describe '.authenticate_with_credentials' do
    before :each do
      @user = User.create!(
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end

    it 'authenticates with valid credentials' do
      user = User.authenticate_with_credentials('john.doe@example.com', 'password')
      expect(user).to eq(@user)
    end

    it 'does not authenticate with invalid credentials' do
      user = User.authenticate_with_credentials('john.doe@example.com', 'wrongpassword')
      expect(user).to be_nil
    end

    it 'authenticates with email containing leading/trailing spaces' do
      user = User.authenticate_with_credentials('  john.doe@example.com  ', 'password')
      expect(user).to eq(@user)
    end

    it 'authenticates with email in different case' do
      user = User.authenticate_with_credentials('JOHN.DOE@EXAMPLE.COM', 'password')
      expect(user).to eq(@user)
    end
  end
end
