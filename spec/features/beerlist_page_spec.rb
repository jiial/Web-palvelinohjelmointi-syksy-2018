require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :selenium do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: ['headless', 'disable-gpu']  }
      )
      
      Capybara::Selenium::Driver.new app,
        browser: :chrome,
        desired_capabilities: capabilities      
    end
    WebMock.disable_net_connect!(allow_localhost: true) 
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name:"Koff")
    @brewery2 = FactoryBot.create(:brewery, name:"Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name:"Ayinger")
    @style1 = Style.create name:"Lager"
    @style2 = Style.create name:"Rauchbier"
    @style3 = Style.create name:"Weizen"
    @beer1 = FactoryBot.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows the known beers", js:true do
    visit beerlist_path
    expect(page).to have_content "Nikolai"
  end

  it "is ordered by name by default", :js => true do
    visit beerlist_path
    first = find('table').find('tr:nth-child(2)')
    expect(first).to have_content @beer2.name
    second = find('table').find('tr:nth-child(3)')
    expect(second).to have_content @beer3.name
    third = find('table').find('tr:nth-child(4)')
    expect(third).to have_content @beer1.name
  end

  it "is ordered by style when style is clicked", :js => true do
    visit beerlist_path
    click_link "style"
    first = find('table').find('tr:nth-child(2)')
    expect(first).to have_content @beer1.name
    second = find('table').find('tr:nth-child(3)')
    expect(second).to have_content @beer2.name
    third = find('table').find('tr:nth-child(4)')
    expect(third).to have_content @beer3.name
  end

  it "is ordered by brewery when brewery is clicked", :js => true do
    visit beerlist_path
    click_link "brewery"
    first = find('table').find('tr:nth-child(2)')
    expect(first).to have_content @beer3.name
    second = find('table').find('tr:nth-child(3)')
    expect(second).to have_content @beer1.name
    third = find('table').find('tr:nth-child(4)')
    expect(third).to have_content @beer2.name
  end
end