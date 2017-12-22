require 'rails_helper'

RSpec.describe "counter_offers/index", type: :view do
  before(:each) do
    assign(:counter_offers, [
      CounterOffer.create!(
        :value => 2,
        :winner_id => 3,
        :accepted_status => false
      ),
      CounterOffer.create!(
        :value => 2,
        :winner_id => 3,
        :accepted_status => false
      )
    ])
  end

  it "renders a list of counter_offers" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
