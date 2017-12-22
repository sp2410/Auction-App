require File.expand_path "../place_bid", __FILE__
require File.expand_path "../twilionotifier", __FILE__

class AuctionSocket

  #initialize
  def initialize app
    @app = app
    @clients = []
  end

#rack call to environment
  def call env
    @env = env
    # for new request create a client and add to the client array
    if socket_request?
    #create socket
      socket = spawn_socket
      @clients << socket
      socket.rack_response
    else
      @app.call env
    end
  end

  private

  attr_reader :env

#if new request
  def socket_request?
    Faye::WebSocket.websocket? env
  end

#rack call to environment
  def spawn_socket
    socket = Faye::WebSocket.new env

    socket.on :open do
      socket.send "Hello!"
    end

    socket.on :message do |event|
      # p event
      socket.send event.data
      begin
        tokens = event.data.split " "
        operation = tokens.delete_at 0

        case operation
        when "bid"
          bid(socket, tokens)
        end

      rescue Exception => e
        p e
        p e.backtrace
      end
    end

    socket
  end

#split the socket message sending three parameters and extract the needed
  def bid (socket, tokens)
    service = PlaceBid.new(
      auction_id: tokens[0],
      user_id: tokens[1],
      value: tokens[2]
    )

    if service.execute
      socket.send "bidok"
      notify_outbids socket, tokens[2]

      #For Twilio
      allusersonbid = Bid.joins(:user).where(:auction_id => tokens[0]).where.not(:user_id => tokens[1]).uniq.pluck(:mobile_Phone_Number)
      
      product_details = Auction.joins(:product).where(:id => tokens[0]).pluck(:product_id,:title)[0]
      
      # send twilio notification
      send_notification(allusersonbid, product_details)

    else
      if service.status == :won
        notify_auction_ended socket
      else
        socket.send "underbid #{service.auction.current_bid.to_i+50}"
      end
    end
  end

        
  
  def send_notification(allusersonbid, product_details)
    @notifier = Twilionotifier.new
    @notifier.notifybidding(allusersonbid, product_details)
  end



  def notify_outbids socket, value
    @clients.reject { |client| client == socket || !same_auction?(client,socket) }.each do |client|
      client.send "outbid #{value}"
    end
  end

  def notify_auction_ended socket
    socket.send "won"

    @clients.reject { |client| client == socket || !same_auction?(client,socket) }.each do |client|
      client.send "lost"
    end
  end

  def same_auction? other_socket, socket
    other_socket.env["REQUEST_PATH"] == socket.env["REQUEST_PATH"]
  end
end