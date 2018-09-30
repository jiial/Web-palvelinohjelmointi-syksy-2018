require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:test_brewery) { FactoryBot.create(:brewery) }

  it "is saved with required information" do
    beer = FactoryBot.create(:beer)

    expect(beer.name).to eq("anonymous")
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create style:"Lager", brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name: "Olut", brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end  
