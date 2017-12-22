require 'emailnotifier'
require 'rails_helper'


require "rails_helper"

describe "send"
  it "sends email" do

    from = 'tdcautoauction@tdcdigitalmedia.com'
	dealers	= User.where.not(:id => product.originaluser_id).uniq.pluck(:email)
		#to = dealers
	subject = "TDCAutoAuction: New Auction Just Started!"
	content = "Hi! Its TDCAutoAuction. \nHope You are doing great today! \nA New Auction just started.\nFollow: https://evening-beach-65902.herokuapp.com/products to bid now! \n\nRegards!\nTDCDiitalMedia,\nPhone: +1 866-338-7870\nEmail:tdcautoauction@tdcdigitalmedia.com"
		
	@notifier = EmailNotifier.new(from, dealers, subject, content)
	@notifier.send
  end
end

