require 'spec_helper'

describe ReactionsController do
  context "User is logged in" do
    describe "get new" do
      it "renders view with reaction form"
    end

    describe "post create" do
      it "creates new reaction"
      it "redirects to reaction page"
      it "adds flash message 'Реакция добавлена'"
    end

    describe "patch update" do
      it "updates reaction title"
      it "ignores new reaction image"
    end

    describe "delete destroy" do
      it "removes reaction from database"
      it "redirects to root page"
      it "adds flash message 'Реакция удалена'"
    end
  end

  context "User is not logged in" do
    describe "get new" do
      it "redirects to login page"
      it "adds flash message 'Необходима авторизация'"
    end

    describe "post create" do
      it "redirects to login page"
      it "adds flash message 'Необходима авторизация'"
    end

    describe "patch update" do
      it "redirects to login page"
      it "adds flash message 'Необходима авторизация'"
    end
  end

  context "Any user" do
    describe "get show" do
      it "renders view with reaction"
    end
  end
end