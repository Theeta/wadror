require 'spec_helper'

describe Beer do
  it "is saved if it has a correct name and style" do
    s = Style.create name: "tyyli", description: "kuvaus"
    beer = Beer.create name:"Olut", style_id: s.id

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
  
  it "is not saved if it has not a name" do
    beer = Beer.create

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
  
end


