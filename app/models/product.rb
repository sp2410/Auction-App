class Product < ApplicationRecord
	
	belongs_to :user
	belongs_to :originaluser, :class_name => "User"
	has_one :auction,  dependent: :destroy 
	has_many :likes,  dependent: :destroy 
	has_many :pictures,  dependent: :destroy 	

	has_one :bill,  dependent: :destroy 
	
	validates_uniqueness_of :vin
	validates_presence_of :vin

	validates_presence_of :name
	validates_presence_of :title

	mount_uploader :image, ImageUploader
	
	mount_uploader :imagefront, ImageUploader
	mount_uploader :imageback, ImageUploader
	mount_uploader :imageleft, ImageUploader
	mount_uploader :imageright, ImageUploader

	mount_uploader :frontinterior, ImageUploader
	mount_uploader :rearinterior, ImageUploader

	# accepts_nested_attributes_for :pictures, :allow_destroy => true


	geocoded_by :full_address
	geocoded_by :city
	after_validation :geocode

	def full_address
		[city, state, zipcode].join(', ')
	end

	def has_auction?
		auction.present?
	end

	scope :view_all, -> { }
	scope :never_on_auction, -> {where.not(:id => Auction.select(:product_id))}
    scope :on_live_auction, -> {joins(:auction).where('auctions.ends_at > ?', DateTime.now)}
    scope :successfully_completed_auctions, -> {joins(:auction).where('products.originaluser_id != NULL AND products.user_id != products.originaluser_id')}
    scope :billed, -> {where('products.billed = ?', true)}
    scope :paid, -> {where('products.stage = ?', "paid")}
    scope :on_hold, -> {where('products.stage = ?', "onhold")}
    scope :reviewed, -> {where('products.stage = ?', "reviewed")}



	enum stage: {:never_auctioned => 'never_auctioned', :live_auction => 'live_auction', :approved => 'approved', :billed => 'billed', :paid => 'paid', :onhold  => 'onhold', :reviewed  => 'reviewed'}
  
  

  	def set_default_role
    	self.stage = :never_auctioned
    	self.billed = false
    		# return true
    end

    
    
	def mark_as_approved
    	self.stage = :approved 
    	self.billed = false
    	p "approved"
    		# return true   		
	end

	def set_as_billed
		
	    	self.stage = :billed
	    	self.billed = true
	    	p "billed"

    		# return true
	end

	def set_as_paid
    	self.stage = :paid
    	self.billed = true
    	p "paid"
    		# return true
	end

	def set_as_onhold
    	self.stage = :onhold
    	p "onhold"
    		# return true
	end

	def mark_as_live_auction
		
		self.stage = :live_auction
    	self.billed = false    		
    	
    	p "live auction"
    		# return true
	end
	

	def paid
		self.stage == "paid" ? true : false
	end



	# def self.onauction
	# 	products = Product.all
	# 	productsonauction = Array.new		

	# 	products.each do |i|
	#       if i.has_auction?
	#         productsonauction << i
	#       end	      
	#     end

	#     return productsonauction
	# end

	# def self.notonauction
	# 	products = Product.all
	# 	productsnotonauction = Array.new		

	# 	products.each do |i|
	#       if !(i.has_auction?)
	#         productsnotonauction << i	
	#       end      
	#     end

	#     return productsnotonauction
	# end


	def self.transfer_product(product)
		product = Product.find_by_id(product.id)

		if product.auction.ended?
			product.update_attribute :user_id, product.auction.top_bid.user_id  
			return true 		   
		end

		return false				
	end

	# Accepting High Bid
	def self.acceptbid(product, user_id)
		product = Product.find_by_id(product.id)

		if ((product.auction.ended?) and (product.originaluser_id == user_id))
			product.update_attribute :sellerselected_option, 1
			product.update_attribute :stage, "approved"
			return true 		   
		end

		return false

	end


	def self.raisecounteroffer(product, user_id)
		product = Product.find_by_id(product.id)	

		if ((product.auction.ended?) and (product.originaluser_id == user_id))
			
			if @product.auction.bids.present?
				@product.auction.bids.destroy_all
			end

			product.update_attribute :sellerselected_option, 2

			return true 		   
		end

		return false

	end


	def self.putback(product)
		product = Product.find_by_id(product.id)

		if ((product.auction.ended?) and (!product.billed))
			@product = Product.find_by_id(product.id)

			if @product.auction.bids.present?
				@product.auction.bids.destroy_all
			end

			if @product.auction.counter_offer.present?
				@product.auction.counter_offer.destroy			
			end
			
			Product.find_by_id(product.id).auction.destroy
			product.update_attribute :user_id, product.originaluser_id
			product.update_attribute :sellerselected_option, 0
			product.update_attribute :stage, "live_auction"

			p "Back On Auction"  
			return true

		end
		
		return false			

	end



	
	def self.acceptoffer(product, user_id)
		
		product = Product.find_by_id(product.id)

		if ((product.auction.ended?) and (product.originaluser_id != user_id) and (product.auction.counter_offer.present?))
			product.auction.counter_offer.update_attribute :winner_id, user_id
			product.auction.counter_offer.update_attribute :accepted_stage, true
			product.update_attribute :stage, "accepted"

			

			return true 		   
		end

		return false
	end




	
	
    
	def self.search(params)
		arr = []

		if params[:location].present?

			
			products = Product.joins(:auction).where('auctions.id is not null and auctions.ends_at >= ?', Time.now)
			
					
			if params[:radius].present?
				products = products.near(params[:location], params[:radius])
			else
				products  = products.near(params[:location])
			end

			arr << products 

			products2 = Product.joins(:auction).where('auctions.id is not null and auctions.ends_at < ?', Time.now)
			
					
			if params[:radius].present?
				products2 = products2.near(params[:location], params[:radius])
			else
				products2 
			end

			arr << products2
			
		end	

		return arr
			
	end





end
