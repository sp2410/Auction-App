class PlaceBid
  attr_reader :auction, :status, :returnvalue, :winner_id

  def initialize options
    @value = options[:value].to_i
    @user_id = options[:user_id].to_i
    @auction_id = options[:auction_id].to_i     
    @returnvalue = 0  
    @winner_id = @user_id    
  end

  def execute
    @auction = Auction.find @auction_id
    

    #if auction ended 
    if ((auction.ended?) && (auction.top_bid.user_id == @user_id))
      @status = :won
      return false
    end

    #if auction value less than current bid
    if (@value <= auction.current_bid)
      return false
    end

    #if auction value greater than current bid but not greater than 50
    # if (((@value - auction.current_bid) < 50) or ((@value - auction.current_bid) > 50))
    #   return false
    # end

    if ((@value - auction.current_bid) < 50)
      return false
    end


    bid = auction.bids.build value: @value, user_id: @user_id

# # #Uncommet from here

#     #if auction value greater than current bid by 50    
#     if ((@value - auction.current_bid ) == 50)      
      
#       #if new bid value greater than proxy bid
#       if (@value > auction.proxybid)        
#         auction.proxybid = @value
#         auction.winner_id = @user_id  
#         bid = auction.bids.build value: @value, user_id: @user_id

#         @returnvalue = @value  
#         @winner_id = @user_id

#         p "hello1"

#       else
#         newvalue = (@value + 50)
#         bid = auction.bids.build value: newvalue, user_id: auction.winner_id

#         @returnvalue = newvalue  
#         @winner_id = auction.winner_id

#         p "hello2"
#       end      

#       if bid.save
#         return true
#       else
#         return false
#       end

#     end

#   #case 3: bid increment greater than 50
#     if ((@value - auction.current_bid ) > 50)

#       #if new bid greater than last proxy bid
#       if (@value > auction.proxybid)        
#         #proxy bid is new proxy bid
#         auction.proxybid = @value
#         #set winner as new bid user id
#         auction.winner_id = @user_id
#         # actualvalue = auction.top_bid        

#         newvalue = auction.top_bid ? (auction.top_bid.value + 50) : 50

#         bid = auction.bids.build value: newvalue, user_id: @user_id  

#         @returnvalue = newvalue  
#         @winner_id = @user_id 

#         p "hello3"
              
#       elsif (@value <= auction.proxybid)        
        
#         newvalue = (@value + 50)

#         bid = auction.bids.build value: newvalue, user_id: auction.winner_id 

#         @returnvalue = newvalue  
#         @winner_id = auction.winner_id 

#         p "hello4"
       
#       end
# # #Uncommet to here

      if bid.save
        return true
      else
        return false
      end    
    # end   
    
  end

end

