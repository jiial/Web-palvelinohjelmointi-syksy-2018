require 'rails_helper'

include Helpers

describe "User" do
  let!(:user) { FactoryBot.create :user }
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery, style:"IPA" }
  let!(:rating1) { FactoryBot.create :rating, score: 17, beer_id: 1, user: user }
  let!(:rating2) { FactoryBot.create :rating, beer_id: 2, user: user }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")
  
      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')
      
      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

    it "can see his favorite beer style and brewery on his page" do
      visit user_path(user)
      expect(page).to have_content "favorite beer style Lager"
      expect(page).to have_content "favorite brewery Koff"
    end
  end
end