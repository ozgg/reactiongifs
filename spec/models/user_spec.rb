require 'spec_helper'

describe User do
  before(:each) { @user = FactoryGirl.build(:user, login: 'random_guy') }

  it 'is invalid when login does not match pattern /\A[a-z0-9_]{1,30}\z/' do
    @user.login = 'bad login'
    expect(@user).not_to be_valid
  end

  it 'converts login to lowercase before validating' do
    @user.valid?
    expect(@user.login).to eq(@user.login.downcase)
  end

  it 'has unique login' do
    @user.save!
    another_user = FactoryGirl.build(:user, login: 'Random_guy')
    expect(another_user).not_to be_valid
  end
end
