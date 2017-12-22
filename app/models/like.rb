class Like < ApplicationRecord
  belongs_to :product
  belongs_to :user

  def getnumber_likes(product)
  	Like.where(:product_id => product.id).count
  end

  def self.like_exits(productid,user)
  	Like.where(:product_id => productid).where(:user_id => user.id)
  end


end
