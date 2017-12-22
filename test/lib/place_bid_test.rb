require "test_helper"
require "place_bid"


class PlaceBidTest < MiniTest::test

	def test_it_places_a_bid
		user = User.create! email: "user@gmail.com", password: "123abc"
		another_user = User.create! email: "user2@gmail.com", password: "123abc"

		product = Product.create! name: "Some Product" 
		auction = Auction.create! value: 10, product_id: product.id

		service = PlaceBid.new value: 11, user_id: another_user, auction_id: auction.id

		service.execute

		assert_equal 11, auction.current_bid

		#bid
	end

end