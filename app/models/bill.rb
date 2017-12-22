class Bill < ApplicationRecord
	belongs_to :product
	has_many :transactions,  dependent: :destroy 

	# attr_accessor :card_number, :card_verification

	# validate :validate_card, :on => :create


	def purchase(price, nonce)
	#     response = GATEWAY.purchase(amount_to_charge, credit_card, purchase_options)
	#     transactions.create!(:action => "purchase", :amount => amount_to_charge, :response => response)	    
	#     response.success?

		nonce = payment_method_nonce
		result = Braintree::Transaction.sale(
			:amount => price_in_cents(price),
			:payment_method_nonce => nonce,
			:options => {
				:submit_for_settlement => true
			}
		)

		result.success?

 	end


  
	def price_in_cents(price)		
		price = price.to_i

		if (price < 5000)

			return (100*100).round

		elsif ((price > 4999) and (price < 10000))

			return (200*100).round			
		else
			return (300*100).round
		end		
				
		return 0	   
	end

 #  	private
  
 #  	def purchase_options
	#     {
	#       :ip => ip_address,
	#       :billing_address => {
	#         :name     => billing_full_name,
	#         :address1 => billing_street_address,
	#         :city     => city,
	#         :state    => state,
	#         :country  => country,
	#         :zip      => zip
	#       }
	#     }
 #  	end
  

	# def validate_card
	#     unless credit_card.valid?
	#       credit_card.errors.full_messages.each do |message|
	#         # errors.add_to_base message	        
	#       end
	#     end
	# end
  
 #  def credit_card
 #    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
 #      :type               => card_type,
 #      :number             => card_number,
 #      :verification_value => card_verification,
 #      :month              => card_expires_on.month,
 #      :year               => card_expires_on.year,
 #      :first_name         => first_name,
 #      :last_name          => last_name
 #    )
 #  end



end
