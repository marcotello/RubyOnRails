require 'test_helper'

class CartTest < ActiveSupport::TestCase
  fixtures :products
  # test "the truth" do
  #   assert true
  # end
  
  test "adding two different products to the cart" do
  	product_one = products(:ruby)
  	product_two = products(:osb)

  	cart = Cart.new
  	line_item = cart.add_product(product_one.id, product_one.price)
  	line_item.save
  	cart.save
  	line_item = cart.add_product(product_two.id, product_two.price)
  	line_item.save
  	cart.save

  	assert_equal cart.line_items.size, 2
  	assert_equal cart.total_price, 107.47
  end
  test "adding two identical products to the cart" do
  	product_one = products(:ruby)
  	#product_two = products(:ruby)

  	cart = Cart.new
  	line_item = cart.add_product(product_one.id, product_one.price)
  	line_item.save
  	cart.save
  	line_item = cart.add_product(product_one.id, product_one.price)
  	line_item.save
  	cart.save

  	assert_equal cart.line_items.size, 1
  	assert_equal cart.total_price, 99
  end
end
