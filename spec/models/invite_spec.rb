require 'spec_helper'

describe Invite do
  let(:invitee) { FactoryGirl.create(:user) }

  it "has user who sends invites" do
    invite = Invite.new(user: nil)
    expect(invite).not_to be_valid
  end

  it "has unique code" do
    FactoryGirl.create(:invite, code: '1234')

    invite = FactoryGirl.build(:invite, code: '1234')

    expect(invite).not_to be_valid
  end

  it "has code matching /([a-z0-9]{4}-){2}[a-z0-9]{4}/" do
    invite = Invite.new
    expect(invite.code).to match(/([a-z0-9]{4}-){2}[a-z0-9]{4}/)
  end

  it "has invitee when activated" do
    invite  = FactoryGirl.create(:invite)
    invite.activate!(invitee)

    expect(invite.invitee).to eq(invitee)
  end

  it "can assign invitee only once" do
    invite  = FactoryGirl.create(:invite, invitee: invitee)

    expect{ invite.activate!(invitee) }.to raise_error(RuntimeError)
  end

  it "is usable with nil invitee" do
    invite = FactoryGirl.create(:invite)

    expect(invite).to be_usable
  end

  it "is not usable with non-nil invitee" do
    invite = FactoryGirl.create(:invite, invitee: invitee)

    expect(invite).not_to be_usable
  end
end