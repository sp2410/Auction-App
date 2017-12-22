require 'rails_helper'

RSpec.describe "reviews/show", type: :view do
  before(:each) do
    @review = assign(:review, Review.create!(
      :approved => false,
      :user => nil,
      :comment => "Comment",
      :rating => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Comment/)
    expect(rendered).to match(/2/)
  end
end
