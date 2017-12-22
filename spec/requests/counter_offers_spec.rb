require 'rails_helper'

RSpec.describe "CounterOffers", type: :request do
  describe "GET /counter_offers" do
    it "works! (now write some real specs)" do
      get counter_offers_path
      expect(response).to have_http_status(200)
    end
  end
end
