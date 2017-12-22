class Auction < ApplicationRecord
  belongs_to :product
  has_many :bids,  dependent: :destroy 
  has_one :counter_offer,  dependent: :destroy 
  # has_one :bill

  validates_numericality_of :value
  validates_presence_of :value


  validate :ends_at_cannot_be_in_the_past

  def top_bid
  	bids.order(value: :desc).first
  end

  def proxy_bid
    bids.order(value: :desc).second
  end

  def current_bid
  	top_bid.nil? ? value : top_bid.value
  end

  def ended?
  	ends_at < Time.zone.now  	
  end

  def has_bid?
    bids.present?
  end

  private

  def ends_at_cannot_be_in_the_past
    if ends_at.present? && ends_at <= Time.now
      errors.add(:ends_at, "can't be in the past")      
      return false
    end
  end  



end
