ActiveAdmin.register Review do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
	permit_params :approved, :user_id, :comment, :rating

	scope :view_all
	scope :approved 
	scope :not_approved

	member_action :accept_review, method: :get do
	    resource.accept_review

	    if resource.save!
	    	redirect_to admin_reviews_path, notice: "Review accepted"       
	    else
	    	redirect_to admin_products_path, notice: "Error while accepting review!'"
	    end
	end


index do

	column "Id", :id
	column "Approved", :approved
	column "Reviewer", :user
	column "Reviewer Id", :user_id
	column "Seller Id", :owner_id
	column "Rating", :rating
	column "Created At", :created_at
	column "Updated At", :updated_at
	
	

	column "" do |resource|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
      links
    end

    column "Approve Review?" do |review|
        link_to "Yes, Approve review", accept_review_admin_review_path(review)
    end


	
end

end