class Order < ActiveRecord::Base
	has_many :line_items, dependent: :destroy
	belongs_to :payment_type

	#PAYMENT_TYPES = ["Check", "Credit Card", "Purchase Order"]

	validates :name, :address, :email, presence: true
	validates :payment_type_id, presence: { message: 'is not selected' }
	validates_presence_of :shipping_date, :if => :shipping_date_required?
	#validate :payment_type_id, inclusion: { in: 1..3 }
	#validates :payment_type_id, numericality: { greater_than: 0, message: 'is not selected' }
	#validates_associated :payment_type
	#validates :payment_type, inclusion: PAYMENT_TYPES

	def add_new_line_items_from_cart(cart)
		cart.line_items.each do |item|
			item.cart_id = nil
			line_items << item
		end
	end

	def shipping_date_required?
		self.id.present?
	end
end
