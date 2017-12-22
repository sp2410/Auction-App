require 'rails_helper'

RSpec.describe "reviews/index", type: :view do
  before(:each) do
    assign(:reviews, [
      Review.create!(
        :approved => false,
        :user => nil,
        :comment => "Comment",
        :rating => 2
      ),
      Review.create!(
        :approved => false,
        :user => nil,
        :comment => "Comment",
        :rating => 2
      )
    ])
  end

  it "renders a list of reviews" do
    render
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
