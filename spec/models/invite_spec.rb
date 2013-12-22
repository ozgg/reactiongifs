require 'spec_helper'

describe Invite do
  it "has user who sends invites"
  it "has code matching /([a-z0-9]{4}-){2}[a-z0-9]{4}/"
  it "has invitee when activated"
  it "can assign invitee only once"
end