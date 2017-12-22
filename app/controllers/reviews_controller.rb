require 'emailnotifier'

class ReviewsController < InheritedResources::Base

	before_action :authenticate_user!, only: [:new, :create, :destroy, :update]	
	
	before_action :set_child_and_parent, only:  [:destroy, :update, :edit]


	def new
		@review = Review.new				
		session[:parent_id] = params[:parent_id]		
		@parent = get_parent(params[:parent_id])		
		@owner = User.find_by_id(@parent.originaluser_id)		
	end

	def edit
		session[:parent_id] = params[:parent_id]		
	end

	def create		
		@review = Review.new(review_params)			
		@review.user_id = current_user.id
		@parent = get_parent(session[:parent_id])
		@owner = User.find_by_id(@parent.originaluser_id)		
		@review.owner_id = @owner.id


						
		respond_to do |format|
			if @review.save!	
							
				@parent.update_attribute :reviewed, true
				@parent.update_attribute :stage, "reviewed"
				@parent.save!

				format.html { redirect_to @parent, notice: 'Review was successfully created.' }
		        format.json { render :show, status: :created, location:@review }
			else				
				format.html { render :new }
		        format.json { render json: @review.errors, status: :unprocessable_entity }
			end
		end
	end

	def update

		@parent = get_parent(session[:parent_id])

		respond_to do |format|
	      	if @review.update(review_params)
		        format.html { redirect_to @parent, notice: 'Review was updated.' }
		        format.json { render :show, status: :ok, location: @parent}
	      	else
		        format.html { render :edit }
		        format.json { render json: @review.errors, status: :unprocessable_entity }
	    	end
    	end
	end


	def destroy		
		session[:parent_id] = params[:parent_id]		
		
		@parent = get_parent(session[:parent_id])		

		@review.destroy
		respond_to do |format|						
		    format.html { redirect_to @parent, notice: 'Review  was successfully destroyed.' }
		    format.json { head :no_content }
		end
	end
	


  private

    def review_params
      params.require(:review).permit(:approved, :user_id, :comment, :rating)
    end

    def set_child_and_parent    	
    	@review = Review.find_by_id(params[:id])
    	@owner = User.find_by_id(params[:user_id])    	
    end    

    def get_parent(parent_id)	    
		return Product.find_by_id(parent_id.to_i)		
    end

    def send_email(review)
		from = 'tdcautoauction@tdcdigitalmedia.com'
		dealers	= ['sales@tdcdigitalmedia.com']
		#to = dealers
		subject = "A New Review has been submitted by a winner. Please accept."
		# content = "<html><body><h1>Hi! Its TDCAutoAuction!</h1><p>Hope You are doing great today! </p><br><p>A New Auction just started.<br><p>Follow: https://evening-beach-65902.herokuapp.com/products/#{product.id} to bid now!</p><br><p>Regards!</p><br><p>TDCDigitalMedia</p><br><p>Phone: +1 866-338-7870</p><br><p>Email:tdcautoauction@tdcdigitalmedia.com</p></body></html>"
		content = "<html><head><style type='text/css'>body,html,.body{background:#D3D3D3!important;}</style></head><body><container><spacer size='16'></spacer><columns large='8'><center><h2>Review id: #{review.id}</h2></center></columns></row><row><columns large='6'><center><h4>Hi! </h4><br><p>A New Review #{review.id} was submitted. Please go to admin/ reviews and approve it to showcase on seller's page.</p><center></columns><columns large='6'><br><p>Phone: +1 866-338-7870 Line 5</p><br><p>Email:tdcautoauction@tdcdigitalmedia.com</p></columns><columns large='4'><img class='small-float-center' width='100px' height='100px' src='https://s3-us-west-2.amazonaws.com/wacbacassetsdonttouch/wacbacassets/TDC.png' alt=''></columns></row><row></row></container><body></html>"		
		@notifier = EmailNotifier.new(from, dealers, subject, content)
		@notifier.send
	end
    


end

