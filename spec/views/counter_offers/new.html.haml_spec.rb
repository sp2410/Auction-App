require 'rails_helper'

RSpec.describe "counter_offers/new", type: :view do
  before(:each) do
    assign(:counter_offer, CounterOffer.new(
      :value => 1,
      :winner_id => 1,
      :accepted_status => false
    ))
  end

  it "renders new counter_offer form" do
    render

    assert_select "form[action=?][method=?]", counter_offers_path, "post" do

      assert_select "input#counter_offer_value[name=?]", "counter_offer[value]"

      assert_select "input#counter_offer_winner_id[name=?]", "counter_offer[winner_id]"

      assert_select "input#counter_offer_accepted_status[name=?]", "counter_offer[accepted_status]"
    end
  end
end
