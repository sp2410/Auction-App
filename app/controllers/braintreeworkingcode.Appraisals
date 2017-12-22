class BillsController < InheritedResources::Base

	before_action :authenticate_user!

	require 'braintree'
	# Braintree::Configuration.environment = :sandbox
	# Braintree::Configuration.logger = Logger.new('log/braintree.log')
	# Braintree::Configuration.merchant_id = ENV['BRAINTREE_MERCHANT_ID']
	# Braintree::Configuration.public_key = ENV['BRAINTREE_PUBLIC_KEY']
	# Braintree::Configuration.private_key = ENV['BRAINTREE_PRIVATE_KEY']

	def new		
		@token = Braintree::ClientToken.generate
		@product = Product.find_by_id(params[:id])
		@bill = Bill.new
	end



	def create
		# @token = Braintree::ClientToken.generate

		@product = Product.find_by_id(params[:product_id])

		@netamount = 0

		#if no auction present

		if (@product.billed)
			redirect_to product_path(@product), notice: 'Oops! Looks Like You Are Too Late, Someone else Accepted The Counter offer Already!'
			return
		end

		if (@product.auction == nil)
			redirect_to product_path(@product), notice: 'Oops! Looks Like You Are Too Late, The Owner Decided To Reject Your Offer This Time'
			return
		end
		#if auction present
		if ((@product.auction.counter_offer != nil) and (@product.auction.counter_offer.winner_id == current_user.id))
			@valuetocharge = @product.auction.counter_offer.value
		elsif ((@product.auction.top_bid != nil) and (@product.auction.top_bid.user_id == current_user.id))
			@valuetocharge = @product.auction.top_bid.value
		else
			redirect_to product_path(@product), notice: 'Oops! Looks Like You Are Too Late, The Owner Decided To Reject Your Offer This Time'
			return
		end

		#Calculations

		if (@valuetocharge < 5000)
			@netamount = "100.00"
		elsif ((@valuetocharge > 4999) and (@valuetocharge < 10000))
			@netamount =  "200.00"
		elsif (@valuetocharge > 9999)
			@netamount = "300.00"
		else
			@netamount = "0.00"
		end
		
		nonce = params[:payment_method_nonce]
		
		result = Braintree::Transaction.sale(
			:amount => @netamount,
			:payment_method_nonce => nonce,
			:options => {
				:submit_for_settlement => true
			}
		)

		if (result.success?)

			Product.transfer_product(@product)

			if @product.originaluser_id.present?
				@dealer = User.find_by_id(@product.originaluser_id)		
			else
				@dealer
			end

				# @dealer = User.find_by_id(@product.originaluser_id)		
			@product.update_attribute(:billed, true)

			render :action => "success"
		else

			render :action => "failure"
		end
				

		# @bill = Bill.new bill_params.merge! product_id: @product.id	

		# if (@product.auction.counter_offer)
		# 	@valuetocharge = @product.auction.counter_offer.value
		# else
		# 	@valuetocharge = @product.auction.top_bid.value
		# end								 

		# if @bill.save!
		# 	@charged = @bill.price_in_cents(@valuetocharge)

		# 	if @bill.purchase(@charged)

		# 		Product.transfer_product(@product)

		# 		if @product.originaluser_id.present?
		# 			@dealer = User.find_by_id(@product.originaluser_id)		
		# 		else
		# 			@dealer
		# 		end

		# 		# @dealer = User.find_by_id(@product.originaluser_id)		
		# 		@product.update_attribute(:billed, true)

		# 		render :action => "success"
		# 	else

		# 		render :action => "failure"
		# 	end
		# else
		# 	render :action => "new"
		# end				
		
	end	



   
    
  private

    def bill_params
      params.require(:bill).permit(:payment_method_nonce)
    end
end

