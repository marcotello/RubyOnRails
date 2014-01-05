class Product < ActiveRecord::Base
	#validates_length_of :title, :minimum => 10, :allow_blank => true
	validates :title, :description, :image_url, presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	#validates :title, uniqueness: true
	#validates_uniqueness_of :title, :message => "this product is already registered"
	validates :title, uniqueness: { message: 'is already stored in the inventory' }
	validates :image_url, allow_blank: true, format: {with: %r{\.(gif|jpg|png)\Z}i, message: 'must be a URL for GIF, JPG or PNG image.'}

	def self.latest
		Product.order(:updated_at).last
	end
end
