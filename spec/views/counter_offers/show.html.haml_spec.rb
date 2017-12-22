require 'rails_helper'

RSpec.describe "counter_offers/show", type: :view do
  before(:each) do
    @counter_offer = assign(:counter_offer, CounterOffer.create!(
      :value => 2,
      :winner_id => 3,
      :accepted_status => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/false/)
  end
end
