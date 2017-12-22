require 'rails_helper'

RSpec.describe "reviews/edit", type: :view do
  before(:each) do
    @review = assign(:review, Review.create!(
      :approved => false,
      :user => nil,
      :comment => "MyString",
      :rating => 1
    ))
  end

  it "renders the edit review form" do
    render

    assert_select "form[action=?][method=?]", review_path(@review), "post" do

      assert_select "input#review_approved[name=?]", "review[approved]"

      assert_select "input#review_user_id[name=?]", "review[user_id]"

      assert_select "input#review_comment[name=?]", "review[comment]"

      assert_select "input#review_rating[name=?]", "review[rating]"
    end
  end
end
