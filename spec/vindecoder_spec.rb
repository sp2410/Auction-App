require "rails_helper"

describe 'Vindecoder'  do 
	describe "#check a car" do 
			
		it "populates listings" do

			a = Vindecoder.new
			b = a.search("2G1FC3D33C9165616")
			# p b
			#b = a.alllisting

			p a.getresponse

		end 		
	end
end



