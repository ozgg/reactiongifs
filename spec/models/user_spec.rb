require 'spec_helper'

describe User do
  before :each do
    @user = User.new login: 'Random_Guy', password: 'secret', password_confirmation: 'secret'
  end

  it 'is valid with valid attributes' do
    @user.should be_valid
  end

  it 'is invalid when login does not match pattern /\A[a-z0-9_]{1,30}\z/' do
    @user.login = 'bad login'
    @user.should_not be_valid
  end

  it 'converts login to lowercase before validating' do
    @user.valid?
    @user.login.should eq(@user.login.downcase)
  end

  it 'has unique login' do
    @user.save!
    another_user = User.new login: 'Random_guy', password: 'aaa', password_confirmation: 'aaa'
    another_user.should_not be_valid
  end
end
