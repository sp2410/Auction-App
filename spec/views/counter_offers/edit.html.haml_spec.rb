require 'rails_helper'

RSpec.describe "counter_offers/edit", type: :view do
  before(:each) do
    @counter_offer = assign(:counter_offer, CounterOffer.create!(
      :value => 1,
      :winner_id => 1,
      :accepted_status => false
    ))
  end

  it "renders the edit counter_offer form" do
    render

    assert_select "form[action=?][method=?]", counter_offer_path(@counter_offer), "post" do

      assert_select "input#counter_offer_value[name=?]", "counter_offer[value]"

      assert_select "input#counter_offer_winner_id[name=?]", "counter_offer[winner_id]"

      assert_select "input#counter_offer_accepted_status[name=?]", "counter_offer[accepted_status]"
    end
  end
end
