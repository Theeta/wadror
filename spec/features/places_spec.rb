require 'spec_helper'
require 'webmock/rspec'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(:id => 1, :name => "Oljenkorsi") ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end
  
  it "if two is returned by the API, it is shown at the page" do
    BeermappingApi.stub(:places_in).with("kallio").and_return(
        [ Place.new(:id => 1, :name => "Baari"), Place.new(:id => 2, :name => "Pubi") ]
    )

    visit places_path
    fill_in('city', with: 'kallio')
    click_button "Search"

    expect(page).to have_content "Baari"
    expect(page).to have_content "Pubi"
  end
  
  it "if none is returned by the API, it is shown at the page" do
    BeermappingApi.stub(:places_in).with("keskusta").and_return(
        []
    )

    visit places_path
    fill_in('city', with: 'keskusta')
    click_button "Search"

    expect(page).to have_content "No locations in keskusta"
  end
end
