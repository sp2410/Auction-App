class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable


  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :dealer_Name
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :zip


  validates_presence_of :dealer_Number
  validates_presence_of :primary_Phone
  # validates_presence_of :zip
  # validates_presence_of :zip
  # validates_presence_of :zip
  # validates_presence_of :zip
  # validates_presence_of :zip



  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

	has_many :products
	has_many :likes,  dependent: :destroy
	has_many :originalproducts, :class_name => "Product", :foreign_key => "originaluser_id",  dependent: :destroy 	

  has_many :reviews, :dependent => :delete_all

	validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

  def self.get_all_approved_reviews(user)
    user.reviews.map {|review| {:rating => review.rating, :comment => review.comment, :email => User.find_by_id(review.user_id).email, :approved => review.approved, :owner_id => review.owner_id}}
  end
end
