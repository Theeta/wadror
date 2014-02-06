require 'spec_helper'

describe "New Beer page" do
  before :each do
    FactoryGirl.create :brewery
  end
  
  it "should be possible to create a new beer with a valid name" do
    visit new_beer_path
    fill_in('beer_name', with:'Olunen')
    
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end
  
  it "should not be possible to create a new beer without a valid name" do
    visit new_beer_path
    click_button "Create Beer"
    expect(page).to have_content "New beer"
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end
