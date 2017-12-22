class PicturesController < ApplicationController
	before_action :authenticate_user!  	

  # GET /pictures
  # GET /pictures.json
  def index
    @product = Product.find(params[:product_id])
    @pictures = Picture.where(:product_id => @product.id)    
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
    @product = Product.find(params[:product_id])    
    @picture = Picture.find(params[:id])
  end

  # GET /pictures/new
  def new
    @product = Product.find(params[:product_id])  
    @picture = Picture.new
    
  end

  # GET /pictures/1/edit
  def edit
    @product = Product.find(params[:product_id])  
    @picture = Picture.find(params[:id])

  end

  # POST /pictures
  # POST /pictures.json
  def create
    @product = Product.find(params[:product_id])  
    @picture = Picture.new(picture_params)
    @picture.product_id = @product.id    

    respond_to do |format|
      if @picture.save
        format.html { redirect_to product_pictures_path(@product.id), notice: 'Picture was successfully created.' }
        format.json { render :show, status: :created, location: product_pictures_path(@product.id) }
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    @product = Product.find(params[:product_id])  
    @picture = Picture.find(params[:id])

    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to product_pictures_path(@product.id), notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: product_pictures_path(@product.id) }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @product = Product.find(params[:product_id])  
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to product_pictures_path(@product.id), notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

    def picture_params
      params.require(:picture).permit(:image, :alias, :product_id)
    end
end

