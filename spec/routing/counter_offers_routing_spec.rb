require "rails_helper"

RSpec.describe CounterOffersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/counter_offers").to route_to("counter_offers#index")
    end

    it "routes to #new" do
      expect(:get => "/counter_offers/new").to route_to("counter_offers#new")
    end

    it "routes to #show" do
      expect(:get => "/counter_offers/1").to route_to("counter_offers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/counter_offers/1/edit").to route_to("counter_offers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/counter_offers").to route_to("counter_offers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/counter_offers/1").to route_to("counter_offers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/counter_offers/1").to route_to("counter_offers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/counter_offers/1").to route_to("counter_offers#destroy", :id => "1")
    end

  end
end
