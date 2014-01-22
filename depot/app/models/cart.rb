class Cart < ActiveRecord::Base
	has_many :line_items, dependent: :destroy

	def add_product(product_id, product_price)
		current_item = line_items.find_by(product_id: product_id)
		#logger.debug "***************** El line item es: #{current_item}"
		if current_item
			#logger.debug "***************** Si entre al if #{current_item.id}"
			current_item.quantity +=1
		else
			current_item = line_items.build(product_id: product_id)
			#copying product price to current item price
			current_item.price = product_price
		end
		#logger.debug "***************** El carro tiene #{line_items.size}"
		current_item
	end

	def total_price
		line_items.to_a.sum {|item| item.total_price}
	end
end
