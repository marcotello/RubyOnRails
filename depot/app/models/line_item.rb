class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  belongs_to :order

  def total_price
  	#product.price * quantity
  	unless price.nil?
  		price * quantity
  	end
  end
end
