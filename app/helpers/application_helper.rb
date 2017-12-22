module ApplicationHelper
	TIMENOW = DateTime.new(2030, 8, 29, 22, 35, 0)
	TIMER = [{"time"=>"one minute", "val"=> TIMENOW + 1.minute},{"time"=>"Half Hour", "val"=> TIMENOW + 0.5.hour},{"time"=>"One Hour", "val"=> TIMENOW + 1.hour}, {"time"=>"One Day", "val"=> TIMENOW + 24.hour}, {"time"=>"Three Days", "val"=> TIMENOW + 3.day}, {"time"=>"Seven Days", "val"=> TIMENOW + 7.day}]
end


 def get_rating_in_star(rating)
      rating = case rating 

      when 1
        then render partial: "layouts/rating1star" 
      when 2
        then render partial: "layouts/rating2star"        
      when 3
        then render partial: "layouts/rating3star"        
      when 4
        then render partial: "layouts/rating4star"        
      when 5
        then render partial: "layouts/rating5star"        
      end
      return rating

    end

    
  def user_is_listing_owner(listing)
        if user_signed_in?
          if listing.user_id == current_user.id
              return true
          end
        end

        return false
  end

  def user_is_review_owner(review)
      if user_signed_in?
        return true if (review.user_id == current_user.id)
      end

      return false
  end    

  def allowreviews(product)

      if user_signed_in?
        p "user if signed in"
        (product.user_id == current_user.id) and (product.originaluser_id != current_user.id) and ((product.stage == "paid") or (product.stage == "reviewed")) and ((DateTime.now > product.auction.ends_at) if product.auction) and ((!product.reviewed)) ? true : false
        # (product.user_id == current_user.id) and (product.status == "paid") and (Date.today > product.auction.ends_at) and (!reservation.reviwed) ? true : false
      else
        return false
      end
            
    end