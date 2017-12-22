require 'emailnotifier'


class BillsController < InheritedResources::Base

	before_action :authenticate_user!

	# require 'braintree'
	# Braintree::Configuration.environment = :sandbox
	# Braintree::Configuration.logger = Logger.new('log/braintree.log')
	# Braintree::Configuration.merchant_id = ENV['BRAINTREE_MERCHANT_ID']
	# Braintree::Configuration.public_key = ENV['BRAINTREE_PUBLIC_KEY']
	# Braintree::Configuration.private_key = ENV['BRAINTREE_PRIVATE_KEY']

	def new		
		# @token = Braintree::ClientToken.generate
		@product = Product.find_by_id(params[:id])
		@bill = Bill.new
	end



	def create
		# @token = Braintree::ClientToken.generate

		@product = Product.find_by_id(params[:product_id])

		@netamount = 0

		@dealer = User.find_by_id(@product.originaluser_id)


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
			@winner = User.find_by_id(@product.auction.counter_offer.winner_id).email

		elsif ((@product.auction.top_bid != nil) and (@product.auction.top_bid.user_id == current_user.id))
			@valuetocharge = @product.auction.top_bid.value
			@winner = User.find_by_id(@product.auction.top_bid.user_id).email
			
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

		#send email

		status = send_email(@product, @netamount, @winner, @dealer)

		p status 

		if (status == true)
			render :action => "success"
			return 
		else
			render :action => "failure"
			return
		end




		
		# nonce = params[:payment_method_nonce]
		
		# result = Braintree::Transaction.sale(
		# 	:amount => @netamount,
		# 	:payment_method_nonce => nonce,
		# 	:options => {
		# 		:submit_for_settlement => true
		# 	}
		# )

		# if (result.success?)

		# 	Product.transfer_product(@product)

		# 	if @product.originaluser_id.present?
		# 		@dealer = User.find_by_id(@product.originaluser_id)		
		# 	else
		# 		@dealer
		# 	end

		# 		# @dealer = User.find_by_id(@product.originaluser_id)		
		# 	@product.update_attribute(:billed, true)

		# 	render :action => "success"
		# else

		# 	render :action => "failure"
		# end
				

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



	def send_email(product, netamount, winner, dealer)
		from = 'newvehicleclaim@tdcdigitalmedia.com'
		dealers	= ["tdcautoauction@tdcdigitalmedia.com","sales@tdcdigitalmedia.com" ]
		#to = dealers
		subject = "A New Winner Wants To Claim Vehicle #{product.vin}"
		# content = "<html><body><h1>Hi! Its TDCAutoAuction!</h1><p>Hope You are doing great today! </p><br><p>A New Auction just started.<br><p>Follow: https://evening-beach-65902.herokuapp.com/products/#{product.id} to bid now!</p><br><p>Regards!</p><br><p>TDCDigitalMedia</p><br><p>Phone: +1 866-338-7870</p><br><p>Email:tdcautoauction@tdcdigitalmedia.com</p></body></html>"
		content = "<html><head><style type='text/css'>body,html,.body{background:#D3D3D3!important;}</style></head><body><container><spacer size='16'></spacer><row><columns><center><img src= #{product.image}></center></columns></row><row><columns large='8'><center><h2>#{product.title}</h2></center></columns></row><row><columns large='6'><center><h4>Hi! A New Claim request has been made by the Winner!</h4><br><p>Net Amount To Be Charged is: #{netamount} </p><br><p>Winner Email is: #{winner} </p><center></columns><columns large='6'><br><p>Please Folow these steps: </p><br>1. Check on TDCautoauction.com if Vehicle Owner didn't restart the auction again by following: http://www.tdcautoauction.com/products/#{product.id} <br> 2. Raise a new Invoice through Wave App and Send the Invoice email to the user for payments</p><br><p>3. After Total Paymets of #{netamount} is received, go to http://www.tdcautoauction.com/admin/products/#{product.id} and a. update User field to the winner's name and b. billed field in product to TRUE to transfer vehicle automatically to the winner on tdcautoauction website and revoke originaluser access to cancel the auction</p><br><p> 4. Also, Inform Winner with the following vehcile owner details: </p><br><h6>Dealer Contact For Inquiry: #{ dealer.email if dealer.email }</h6><h6>Post Added By: #{ dealer.name if dealer.name }</h6><h6>Dealer Name: #{ dealer.dealer_Name if dealer.dealer_Name }</h6><h6>Dealer Address: #{ dealer.address if dealer.address }</h6><h6>Dealer City: #{ dealer.city if dealer.city }</h6><h6>Dealer State: #{ dealer.state if dealer.state }</h6><h6>Dealer Zip: #{ dealer.zip if dealer.zip }</h6><h6>Dealer Primary Phone : #{ dealer.primary_Phone if dealer.primary_Phone }</h6><h6>Dealer Mobile Phone: #{ dealer.mobile_Phone_Number if dealer.mobile_Phone_Number }</h6><br><p>Thank You! </p></columns><columns large='4'><img class='small-float-center' width='100px' height='100px' src='https://s3-us-west-2.amazonaws.com/wacbacassetsdonttouch/wacbacassets/TDC.png' alt=''></columns></row><row></row></container><body></html>"
		
		@notifier = EmailNotifier.new(from, dealers, subject, content)
		@notifier.send
	end


end

