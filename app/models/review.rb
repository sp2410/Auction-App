class Review < ApplicationRecord
  	belongs_to :user

  	scope :view_all, -> { }
	scope :approved, -> {where(:approved => true)}
	scope :not_approved, -> {where(:approved => false)}

	def self.get_average_rating(owner_id)
		overall_rating = Review.where('owner_id = ? and approved = ?', owner_id, true).average(:rating)
		# overall_rating = Review.where('owner_id = ?', owner_id).average(:rating)
		((overall_rating == nil) or (overall_rating == 0)) ? 5 : overall_rating.to_i

	end

	def accept_review		
		self.approved = true  		  	   	    	    
	end

end
