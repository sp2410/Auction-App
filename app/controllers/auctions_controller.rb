# require File.expand_path "../../lib/emailnotifier", __FILE__
require 'emailnotifier'

class AuctionsController  < ApplicationController
	include ApplicationHelper

	before_action :authenticate_user!
	

	def create
		@product = Product.find(params[:product_id])
		if @product.stage == "onhold"
			redirect_to @product, alert: "This product has been put on hold. Its undergoing investigations and can't be put on auction. Please contact us to resolve the issue"
		else 

			@auction = Auction.new auction_params.merge! product_id: @product.id		

			if @auction.save!
				@auction.update_attribute :ends_at, DateTime.now + ((@auction.ends_at - DateTime.new(2030, 8, 29, 22, 35, 0))*1.second).second
				# p "auction ends at #{@auction.ends_at}"
				# p "Time now #{DateTime.now}"
				# p "net value #{DateTime.now + ((@auction.ends_at - DateTime.new(2030, 8, 29, 22, 35, 0))*1.second).second}"
				@product.update_attribute :sellerselected_option, 0
				@product.update_attribute :stage, "live_auction"
				redirect_to @product, notice: "Product put on Auction."
				p "start"
				send_email(@product)
				p "end"
			else
				redirect_to @product, alert: "Couldn't gather either the current time or the amount. Please make sure a minimum value is present and auction end time time is in future!"
			end

		end		
	end

	private 

	def auction_params
		params.require(:auction).permit(:value,:ends_at)
	end


	def send_email(product)
		from = 'tdcautoauction@tdcdigitalmedia.com'
		dealers	= User.where(:receiveemail => true).where.not(:id => product.originaluser_id).uniq.pluck(:email)
		#to = dealers
		subject = "A New Auction On Vehicle VIN #{product.vin} Just Started!"
		# content = "<html><body><h1>Hi! Its TDCAutoAuction!</h1><p>Hope You are doing great today! </p><br><p>A New Auction just started.<br><p>Follow: https://evening-beach-65902.herokuapp.com/products/#{product.id} to bid now!</p><br><p>Regards!</p><br><p>TDCDigitalMedia</p><br><p>Phone: +1 866-338-7870</p><br><p>Email:tdcautoauction@tdcdigitalmedia.com</p></body></html>"
		content = "<html><head><style type='text/css'>body,html,.body{background:#D3D3D3!important;}</style></head><body><container><spacer size='16'></spacer><row><columns><center><img src=#{product.image}></center></columns></row><row><columns large='8'><center><h2>#{product.title}</h2></center></columns></row><row><columns large='6'><center><h4>Hi! Its TDCAutoAuction!</h4><br><p>A New Auction just started.</p><br><p>Follow: http://www.tdcautoauction.com/products/#{product.id} to bid now!</p><center></columns><columns large='6'><br><p>Phone: +1 866-338-7870 Line 5</p><br><p>Email:tdcautoauction@tdcdigitalmedia.com</p></columns><columns large='4'><img class='small-float-center' width='100px' height='100px' src='https://s3-us-west-2.amazonaws.com/wacbacassetsdonttouch/wacbacassets/TDC.png' alt=''></columns></row><row></row></container><body></html>"
		
		@notifier = EmailNotifier.new(from, dealers, subject, content)
		@notifier.send
	end

end

