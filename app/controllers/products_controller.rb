class ProductsController < ApplicationController
  before_action :authenticate_user!, :except => [:index]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    @productsonauctionmap =  Product.joins(:auction).where('auctions.id is not null and auctions.ends_at >= ?', Time.now).order( 'updated_at DESC' )
    @productsonauction = @productsonauctionmap.all.order( 'updated_at DESC' ).limit(25)
    @productsnotonauction = Product.joins(:auction).where('auctions.id is not null and auctions.ends_at < ?', Time.now).order( 'updated_at DESC' )
    
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @owner_id = @product.originaluser_id    
    # @reviews = Review.where('owner_id = ?', @owner_id)
    @reviews = Review.where('owner_id = ?', @owner_id).where('reviews.approved = ?', true)
    
    # Review.joins(:user).where('reviews.approved = ?', true).where('users.id = ?', @owner_id)
  end

  # GET /products/new
  def new
    @product = Product.new

  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.title = "#{product_params[:year] + " " +  product_params[:name] +" " + product_params[:model]}"

    @product.user = current_user
    @product.originaluser_id = current_user.id

    @product.city = current_user.city if current_user.city.present?
    @product.state = current_user.state if current_user.state.present?
    @product.zipcode = current_user.zip if current_user.zip.present?

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update

    if (@product.auction != nil)
      redirect_to @product, notice: "Sorry! You can't update the product details once you started an auction"
      return 
    end

      @product.title = "#{product_params[:year] + " " +  product_params[:name] +" " + product_params[:model]}"
      @product.user = current_user
      @product.originaluser_id = current_user.id

      @product.city = current_user.city if current_user.city.present?
      @product.state = current_user.state if current_user.state.present?
      @product.zipcode = current_user.zip if current_user.zip.present?

    respond_to do |format|    


      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # def transfer
  #   product = Product.find params[:id]
  #   p "trasfer started"

  #   if product.auction.ended?
  #     p "trasferring"
  #     product.update_attribute :user_id, product.auction.top_bid.user_id      
  #   else    
  #   end 
       
  # end

  def putback

    @product = Product.find params[:id]

    if (@product.auction.present?)      
            if ((@product.auction.ended?) and (current_user.id == @product.originaluser_id))
              if (@product.auction.top_bid.present?)
                if((@product.originaluser_id) == (current_user.id))
                    @success =  Product.putback(@product)
                          
                    if (@success)              
                      redirect_to product_path(@product), notice: 'Start With A New Auction Again!' 
                    else
                        
                      redirect_to product_path(@product), notice: 'Something went wrong!'             
                    end 
                else
                  redirect_to product_path(@product), notice: 'Sorry! You Dont Have The Permission'
                end
              else

                  @success =  Product.putback(@product)
                          
                  if (@success)              
                    redirect_to product_path(@product), notice: 'Great! Start With A New Auction Again' 
                  else
                    redirect_to product_path(@product), notice: 'Something went wrong!'             
                  end 
              end
            else          
              redirect_to product_path(@product), notice: 'Watch What You Doing!' 
            end
      else
        redirect_to product_path(@product), notice: 'Watch What You Doing!' 
      end   
  end

  def acceptbid

    set_product

    if (@product.auction.present?)
        if (@product.auction.ended?)
          if (@product.auction.top_bid.present?)
            @success =  Product.acceptbid(@product, current_user.id)

            if (@success)
              redirect_to product_path(@product), notice: 'Great! You Have Accepted The Highest Bid! We will Notify The Highest Bidder'
            else
              redirect_to product_path(@product), notice: 'Oops! Something went wrong, contact us if you are facing problems!'
            end 

          else 
            redirect_to product_path(@product), notice: 'No! Bidding Done yet' 
          end

        else
            redirect_to product_path(@product), notice: 'Oops! Something went wrong, contact us if you are facing problems!'                       
        end

    else
        redirect_to product_path(@product), notice: 'Watch What You Doing!' 
    end 
  end


  # def cancelcounteroffer

  #   set_product

  #   if (@product.auction.present?)
  #       if (@product.auction.ended?)
  #         if (@product.auction.top_bid.present?)
  #           @success =  Product.cancelcounteroffer(@product)

  #           if (@success)
  #             redirect_to product_path(@product), notice: 'Great! Start With A New Auction Again!' 
  #           else
  #             redirect_to product_path(@product), notice: 'Oops! Something went wrong, contact us if you are facing problems!'
  #           end 

  #         else 
  #           redirect_to product_path(@product), notice: 'No! Bidding Done yet' 
  #         end

  #       else
  #           redirect_to product_path(@product), notice: 'Oops! Something went wrong, contact us if you are facing problems!'                       
  #       end

  #   else
  #       redirect_to product_path(@product), notice: 'Watch What You Doing!' 
  #   end 
  # end


  def acceptcounteroffer


    set_product

    if (@product.auction.present?)
        if (@product.auction.ended?)
          if (@product.auction.top_bid.present?)

            if (current_user.id != @product.originaluser_id)

              @success =  Product.acceptoffer(@product, current_user.id)

              if (@success)                
                redirect_to new_product_bill_path(@product), notice: 'Great! You Have Accepted The Counter Offer From The Seller! Please Go Ahead And Pay The Service Fee or Contact Us for Paying Fees Directly'
              else
                redirect_to product_path(@product), notice: 'Oops! Something went wrong, contact us if you are facing problems!'
              end 
            else
              redirect_to product_path(@product), notice: 'You Cant Accept Your Own Offer!'
            end

          else 
            redirect_to product_path(@product), notice: 'No! Bidding Done yet' 
          end

        else
            redirect_to product_path(@product), notice: 'Oops! Something went wrong, contact us if you are facing problems!'                       
        end

    else
        redirect_to product_path(@product), notice: 'Watch What You Doing!' 
    end 



  end




  def liveauction        
    @productsonauction = Product.joins(:auction).where('auctions.id is not null and auctions.ends_at >= ?', Time.now).all.order( 'updated_at DESC' ).page(params[:page]).per(35)    

  end

  def pastauction
    @productsnotonauction = Product.joins(:auction).where('auctions.id is not null and auctions.ends_at < ?', Time.now).all.order( 'updated_at DESC' ).page(params[:page]).per(35)

  end

  def purchases
    @orignalproducts = Product.where(:originaluser_id => current_user.id)
    @wonproducts = Product.where(:user_id => current_user.id).where.not(:originaluser_id => current_user.id)
  end


  def yourbids    
    @yourbids = Product.where(id: Auction.joins(:bids).select(:product_id).where("bids.user_id = #{current_user.id}")).where.not(:originaluser_id => current_user.id).page(params[:page]).per(35)
  end


  def search    
    search = Product.search(params)
    @products = search[0]
    @products2 = search[1]
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :image, :title, :description, :city, :state, :zipcode, :latitude, :longitude, :year, :miles, :transmission, :color, :cylinder, :fuel, :drive, :newused, :vin, :stocknumber, :model, :trim, :enginedescription, :interiorcolor, :options, :originaluser_id,:bluebook, :miles_bluebook, :runs_condition,:drives_condition,:tires_condition,:paint_condition,:windshield_condition,:interior_condition,:check_engine_light,:ABS_light,:Airbag_light,:check_type,:billed, :warranty, :sellerselected_option,:imagefront, :imageback, :imageleft, :imageright, :rearinterior, :frontinterior, :reviewed)
    end
end


