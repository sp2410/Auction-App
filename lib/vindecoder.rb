# require 'json'

# class Vindecoder

# 	include HTTParty

# 	attr_accessor :base_uri , :result

# 	def intialize
# 		@base_uri = ""
# 	end

# 	def search(vin)
# 		p ENV['EDMUNDS_API_KEY']
# 		p vin 
		
# 		@response = HTTParty.get("https://api.edmunds.com/api/vehicle/v2/vins/"+vin+"?fmt=json&api_key=#{ENV['EDMUNDS_API_KEY']}")
# 		@body = JSON.parse(@response.body)
		
# 		return @body
# 	end


# 	def getresponse
# 		@finalarray = []

# 		@body.each do |i|
# 			p i
# 			p "hello"
# 			p "\n"

# 			# p i[1]["name"]
# 			# if i["make"]				
# 			# 	if (i["make"]["name"].to_s)
# 			# 		i["make"]["name"]
# 			# 		@finalarray << i		
# 			# 		p "hello"			
# 			# 	end
# 			# end			
# 		end
		
# 		return @finalarray
# 	end

	

# end
