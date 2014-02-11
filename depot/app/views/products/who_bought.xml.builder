xml.instruct!
xml.orders do
	@product.orders.each do |order|
		xml.order do
			xml.id order.id
			xml.customer order.name
			xml.paymentType order.pay_type
			xml.adress order.address
			xml.products do
				order.line_items.each do |item|
					xml.product item.product.title
					xml.quantity item.quantity
					xml.totalPrice number_to_currency item.total_price
				end
			end
			xml.orderPrice number_to_currency(order.line_items.map(&:total_price).sum)
		end
	end
end