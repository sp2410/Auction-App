ActiveAdmin.register Product do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# require 'lib/emailnotifier.rb'
# require 'lib/twilionotifier.rb'

    scope :view_all
	scope :never_on_auction
    scope :on_live_auction
    scope :successfully_completed_auctions
    scope :billed
    scope :paid 
    scope :onhold    
    
    



permit_params :name, :image, :title, :description, :city, :state, :zipcode, :latitude, :longitude, :year, :miles, :transmission, :color, :cylinder, :fuel, :drive, :newused, :vin, :stocknumber, :model, :trim, :enginedescription, :interiorcolor, :options, :originaluser_id, :bluebook, :miles_bluebook, :runs_condition,:drives_condition,:tires_condition,:paint_condition,:windshield_condition,:interior_condition,:check_engine_light,:ABS_light,:Airbag_light,:check_type,:billed, :warranty, :sellerselected_option,:imagefront, :imageback, :imageleft, :imageright, :rearinterior, :frontinterior, :stage


controller do 

    def send_email_with_product_details(product, subject, message, user)
      from = 'tdcautoauction@tdcdigitalmedia.com'          
      content = "<html><head><style type='text/css'>body,html,.body{background:#D3D3D3!important;}</style></head><body><container><spacer size='16'></spacer><row><columns><center><img class='small-float-center' width='500px' height='300px' src=#{Product.find_by_id(product.id).image}></center></columns></row><row><columns large='8'><center><h2>TDC Auto Auction</h2></center></columns></row><row><columns large='6'><center><h4>Hi! Its TDC Auto Auction team!</h4><br><p>#{message}</p><br><p>Follow: http://www.tdcautoauction.com/products/#{product.id} to view</p><center></columns><columns large='6'><br><p>Phone: +1 866-338-7870 Line 5</p><br><p>Email:tdcautoauction@tdcdigitalmedia.com</p></columns><columns large='4'><img class='small-float-center' width='100px' height='100px' src='//s3-us-west-2.amazonaws.com/rvnb/rvnblogo.jpg' alt='TDC Auto Auction'></columns></row><row></row></container><body></html>"
      notifier = EmailNotifier.new(from, user, subject, content)
      notifier.send
    end

    # def getpayment(user)
    #   @payment = Payment.where('user_id = ?', user.id).first
    #   @payment == nil ? false : @payment        
    # end

    def send_text(send_to, message)
      @notifier = Twilionotifier.new
      @notifier.notify_through_text(send_to, message)
    end
   

    # def get_owners_contact(reservation)
    #     user = get_reservation_listing_owner(reservation)        
    #     getpayment(user) == false ? get_reservation_listing_owner(reservation).email : getpayment(user)
    # end

    # def get_pickup_address(reservation)
    #     owner = get_reservation_listing(reservation)
    #     address = owner.pickup_street_address + "\n" + owner.pickup_city + ", " + owner.pickup_state + ", " + owner.pickup_zipcode
    # end
        

    #  def get_reservation_listing_owner(reservation)
    #     user = User.find_by_id(Listing.find_by_id(reservation.listing_id).user_id)
    #     return user
    # end

    #  def get_reservation_listing(reservation)
    #     @listing = Listing.find_by_id(reservation.listing_id)
    #     return @listing
    # end


end

member_action :markasneverauctioned, method: :get do
    resource.set_default_role
    resource.user_id = resource.originaluser_id
    resource.reviewed = false
               
    if resource.save!        
    	redirect_to admin_products_path, notice: "Stage marked as not on auction!"        
    else
    	redirect_to admin_products_path, notice: "Error while changing stage!'"
    end

end

member_action :markasapproved, method: :get do
    resource.mark_as_approved
    resource.reviewed = false

    resource.user_id = resource.originaluser_id

    if resource.save!        
        redirect_to admin_products_path, notice: "Stage marked as approved"        
    else
        redirect_to admin_products_path, notice: "Error while changing stage!'"
    end

end


member_action :markasbilled, method: :get do
    resource.set_as_billed
    resource.reviewed = false

    if resource.save!
    	redirect_to admin_products_path, notice: "Stage marked as billed!"
        @originaluser = User.find_by_id(resource.user_id) 
        @user = User.find_by_id(resource.auction.top_bid.user_id)
        begin         
            send_email_with_product_details(resource, "TDC Auto Auction: Auction fees invoice sent", "TDC Auto Auction: Hi! The Auction on vehicle VIN #{resource.vin} was accepted. We have sent you an invoice, please check your email inbox for the email you used to login", ["#{@user.email}"])                      
        rescue
                p "active admin error in markasbilled email"
        end                            
    else
    	redirect_to admin_products_path, notice: "Error while changing stage!'"
    end

end


member_action :mark_as_live_auction, method: :get do
    @updateable = resource.mark_as_live_auction

    # if @updateable == true
    resource.user_id = resource.originaluser_id

    if resource.save!
        redirect_to admin_products_path, notice: "Stage marked as live auction!"
    else
        redirect_to admin_products_path, notice: "Error while changing stage!"
    end
    # else
    #     redirect_to admin_products_path, notice: "The product is not on live auction. Status cant be changed to live auction"
    # end


end


member_action :markaspaid , method: :get do
    resource.set_as_paid
    resource.reviewed = false

    @originaluser = User.find_by_id(resource.originaluser_id) 
    @user = User.find_by_id(resource.auction.top_bid.user_id) 

    resource.user_id = @user.id

    if (resource.save!) and (resource.auction.ended?) and (@originaluser.id != @user.id)  and (@user.id != nil)
    	redirect_to admin_products_path, notice: "Status marked as paid!"
                
	        begin
	            send_email_with_product_details(resource, "TDC Auto Auction: Auction fees was accepted", "Hi! The payment on car VIN #{resource.vin} was accepted. We have made your contact informations available to #{@user.email}. Please get in touch or wait from the auction winner to contact you", ["#{@originaluser.email}"])
	        rescue
	            p "active admin error in seller "
	        end

	        begin
	            send_email_with_product_details(resource, "TDC Auto Auction: Payments accepted! View Seller Details", "Hi! The payment on car id #{resource.vin} was accepted. Here are the seller details: Email: #{@originaluser.email if @originaluser.email}, \n Name: #{@originaluser.name if @originaluser.name}, \n Phone: #{@originaluser.primary_Phone if @originaluser.primary_Phone}, Mobile Phone: #{@originaluser.mobile_Phone_Number if @originaluser.mobile_Phone_Number}, \n City: #{@originaluser.city if @originaluser.city}, State: #{@originaluser.state if @originaluser.state}, Zipcode: #{@originaluser.zip if @originaluser.zip}", ["#{@user.email}"])        
	        rescue
	            p "active admin error in winner email"
	        end
	    

	        if (@user.mobile_Phone_Number.present?)
	            begin
	                send_text(@user.mobile_Phone_Number, "Hi! The payment on car VIN: #{resource.vin} was accepted. Here are the seller details: Email: #{@originaluser.email if @originaluser.email} \n Name: #{@originaluser.name if @originaluser.name} \n Phone: #{@originaluser.primary_Phone if @originaluser.primary_Phone}, Mobile Phone: #{@originaluser.mobile_Phone_Number if @originaluser.mobile_Phone_Number} \n City: #{@originaluser.city if @originaluser.city}, State: #{@originaluser.state if @originaluser.state}, Zipcode: #{@originaluser.zip if @originaluser.zip}")
	            rescue
	                p "active admin error in markaspaid text"
	            end
	        end

    else
    	redirect_to admin_products_path, notice: "Error while changing status!'"
    end
end



member_action :markasonhold, method: :get do
    resource.set_as_onhold

   if resource.save!
    	redirect_to admin_products_path, notice: "Status marked as onhold"
        @originaluser = User.find_by_id(resource.originaluser_id)        
        
        begin
        	send_email_with_product_details(resource, "TDC Auto Auction: Your vehicle is on hold", "Hi! Your car VIN #{resource.vin} has been put on hold. Kindly contact us to resolve the situation. ", ["#{@originaluser.email}"])        
        rescue
            p "active admin error in markasonhold email"
        end

        if (@originaluser.mobile_Phone_Number.present?)

	        begin
	        	send_text(@user.mobile_Phone_Number, "Your car VIN #{resource.vin} has been put on hold. Kindly contact us to resolve the situation.")
	        rescue
	        	p "active admin error in markasonhold text"
	        end        
	    end
    else
    	redirect_to admin_products_path, notice: "Error while changing status!'"
    end
end



member_action :askforreview, method: :get do

    @user = User.find_by_id(resource.user_id)
    @originaluser = User.find_by_id(resource.originaluser_id)        
    
    #send an email

        if ((resource.stage == "paid") and (@user.id != @originaluser.id) and (@user.id != nil))
            begin
                send_email_with_products_details(resource, "TDC Auto Auction: Need reviews for your last auction experience. Seller is waiting for your reviews", "We hope you enjoyed the auction on vehicle #{resource.vin}. For us you are a very important customer and we would request your reviews for the overall experience and recommendations. Please go to the vehicle page: http://www.tdcautoauction.com/products/#{resource.id} and you will see a link waiting specifically for your review.  ", ["#{@user.email}"])         
            rescue
                p "active admin error in askforreview email"
            end

            
       		if (@user.mobile_Phone_Number.present?)
	           	begin
	                send_text(@user.mobile_Phone_Number, "We hope you enjoyed the auction on vehicle #{resource.vin}. For us you are a very important customer and we would request your reviews for the overall experience and recommendations. Please go to the vehicle page: http://www.tdcautoauction.com/products/#{resource.id} and you will see a link waiting specifically for your review.")
	            rescue
	                p "active admin error in askforreview text"
	            end
	        end
        
            redirect_to admin_products_path, notice: "Email and text for review has been sent"
        else
            redirect_to admin_products_path, notice: "Oops! Error while changing sending review request."            
            # redirect_to admin_reservations_path, notice: "Error while sending email"
        end

end
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

index do
	column :id
	column "Vin", :vin
	column "Stocknumber", :stocknumber
	

	column "" do |resource|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
      links
    end
    column "Stage", :stage
    column "Billed", :billed

	column "Invoice sent?" do |product|
    	link_to "Yes, Mark as Billed and inform buyer", markasbilled_admin_product_path(product)
    end
    column "Payment Received?" do |product|
    	link_to "Yes, Mark as Paid, send information to buyer, inform seller and transfer vehicle", markaspaid_admin_product_path(product)
    	# , markaspaid_admin_reservation_path(reservations)
    end
    column "Put on Hold?" do |product|
    	link_to "Yes, Put on hold and inform seller", markasonhold_admin_product_path(product)
    	# , markasonhold_admin_reservation_path(reservations)
    end

    column "Mark as Not On Auction?" do |product|
    	link_to "Yes, Go back and mark as Not on Auction", markasneverauctioned_admin_product_path(product)
    end

    column "Mark as Approved?" do |product|
        link_to "Yes, Go back and mark as Approved(Auction bid) by the seller", markasapproved_admin_product_path(product)
    end

    column "Mark as on Live Auction?" do |product|
        link_to "Yes, Mark as on Live auction (First check if the product is on live auction)", mark_as_live_auction_admin_product_path(product)
    end

    
    # column "Reviewed", :reviwed

    column "Ask Winner for reviews?" do |product|
        link_to "Yes, request buyer a review through email", askforreview_admin_product_path(product)        
    end

    


	column "Name", :name
	column "Image", :image
	column "Created At", :created_at
	column "Updated At", :updated_at	
	column "Original User Id", :originaluser_id
	column "User Id (Owner changes after vehicle transfer)", :user_id
	column "Description", :description
	column "City", :city
	column "State", :state
	column "Zipcode", :zipcode
	column "Year", :year
	column "Transmission", :transmission
	column "Color", :color
	column "Cylinder", :cylinder
	column "Fuel", :fuel
	column "Newused", :newused
	
	column "Model", :model
	column "Trim", :trim
	column "Enginedescription", :enginedescription
	column "Interiorcolor", :interiorcolor
	column "Options", :options

	column "Runs Condition", :runscondition
	column "Drives Condition", :drives_condition
	column "Tires Condition", :tires_condition
	column "Paint Condition", :paint_condition
	column "Windshield Condition", :windshield_condition
	column "Interior Condition", :interior_condition
	column "Check Engine Light", :check_engine_light
	column "Abs Light", :abs_light

	column "Airbag Light", :airbag_light
	column "Check Type", :check_type
	
	column "Warranty", :warranty
	column "Sellerselected Option", :sellerselected_option

	column "Image Front", :imagefront
	column "Image Back", :imageback
	column "Image Left", :imageleft
	column "Image Right", :imageright
	column "Front Interior Image", :frontinterior
	column "Rear Interior Image", :rearinterior




end





end
