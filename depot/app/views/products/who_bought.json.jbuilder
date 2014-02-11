json.array!(@product.orders) do |order|
   json.extract! order, :id, :name, :pay_type, :address
   json.orderPrice number_to_currency(order.line_items.map(&:total_price).sum)
   json.products order.line_items do |json, item|   
      json.product item.product.title
      json.quantity item.quantity
	  json.totalPrice number_to_currency item.total_price
   end
end