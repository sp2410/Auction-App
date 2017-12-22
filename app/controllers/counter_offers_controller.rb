class CounterOffersController < InheritedResources::Base

require 'emailnotifier'

	def create    
		@product = Product.find(params[:product_id])
	    service = CounterOffer.new counter_offer_params.merge! owner_id: @product.originaluser_id
	    @product.update_attribute :sellerselected_option, 2

	    if service.save        
	    	p "start"			
	      redirect_to product_path(params[:product_id]), notice: "Counter offer Raised!"      
	      send_email(@product)
			p "end"	    
	    else
	      redirect_to product_path(params[:product_id]), alert: "Oops! Something went wrong"
	    end
  	end

  	private

	def counter_offer_params
		params.require(:counter_offer).permit(:value).merge!(      
	      auction_id: params[:auction_id]      
	    )
	end


	def send_email(product)
		from = 'tdcautoauction@tdcdigitalmedia.com'
		dealers	= User.where(:receiveemail => true).where.not(:id => product.originaluser_id).uniq.pluck(:email)
		#to = dealers
		subject = "A Counter Offer Has Been Sent On Vehicle VIN #{product.vin}!"
		# content = "<html><body><h1>Hi! Its TDCAutoAuction!</h1><p>Hope You are doing great today! </p><br><p>A New Auction just started.<br><p>Follow: https://evening-beach-65902.herokuapp.com/products/#{product.id} to bid now!</p><br><p>Regards!</p><br><p>TDCDigitalMedia</p><br><p>Phone: +1 866-338-7870</p><br><p>Email:tdcautoauction@tdcdigitalmedia.com</p></body></html>"
		content = "<html><head><style type='text/css'>body,html,.body{background:#D3D3D3!important;}</style></head><body><container><spacer size='16'></spacer><row><columns><center><img src=#{product.image}></center></columns></row><row><columns large='8'><center><h2>#{product.title}</h2></center></columns></row><row><columns large='6'><center><h4>Hi! Its TDCAutoAuction!</h4><br><p>The Vehicle Owner Sent A Counter Offer!.</p><br><p>Follow the link to accept this offer: http://www.tdcautoauction.com/products/#{product.id} to accept the direct offer!</p><center></columns><columns large='6'><br><p>Phone: +1 866-338-7870 Ext 5</p><br><p>Email:tdcautoauction@tdcdigitalmedia.com</p></columns><columns large='4'><img class='small-float-center' width='100px' height='100px' src='https://s3-us-west-2.amazonaws.com/wacbacassetsdonttouch/wacbacassets/TDC.png' alt=''></columns></row><row></row></container><body></html>"
		
		@notifier = EmailNotifier.new(from, dealers, subject, content)
		@notifier.send
	end


end




