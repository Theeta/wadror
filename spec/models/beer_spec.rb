require 'spec_helper'

describe Beer do
  it "is saved if it has a correct name and style" do
    beer = Beer.create name:"Olut", style:"Lager"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
  
  it "is not saved if it has not a name" do
    beer = Beer.create style:"Lager"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
  
  it "is not saved if it has not a style" do
    beer = Beer.create name:"Olut"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end


