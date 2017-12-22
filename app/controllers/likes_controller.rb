class LikesController < ApplicationController
	before_action :authenticate_user!
	def create
		#if !(Like.like_exits(params[:product_id], current_user).present?)
	    like = Like.new likes_params
	    if like.save
	      redirect_to product_path(params[:product_id]), notice: "You Liked!"
	    else
	      redirect_to product_path(params[:product_id]), alert: "Something went wrong"
	    end
	end

  private

  def likes_params
    params.require(:like).permit(
      user_id: current_user.id,
      product_id: params[:product_id]
    )
  end
end