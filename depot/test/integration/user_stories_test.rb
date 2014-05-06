require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
	fixtures :products

	# USER STORY 

	# A user goes to the index page. They select a product, adding it to their
	# cart, and check out, filling in their details on the checkout form. When
	# they submit, an order is created containing their information, along with a
	# single line item corresponding to the product they added to their cart.


	def buying_a_product
		# Deleting all data from the database
		LineItem.delete_all
		Order.delete_all

		ruby_book = products(:ruby)

		# A user goes to the store index page
		get "/"
		assert_response :success
		assert_template "index"

		# They select a product, adding it to their cart
		xml_http_request :post, '/line_items', product_id: ruby_book.id
		assert_response :success

		cart = Cart.find(session[:cart_id])
		assert_equal 1, cart.line_items.size
		assert_equal ruby_book, cart.line_items[0].product

		# Check out
		get "/orders/new"
		assert_response :success
		assert_template "new"

		# Place Order
		post_via_redirect "/orders", order: { name: "Dave Thomas", address: "123 The Street", email: "dave@example.com", payment_type_id:"2" }
		assert_response :success
		assert_template "index"
		cart = Cart.find(session[:cart_id])
		assert_equal 0, cart.line_items.size

		# Check the Databse is correct
		orders = Order.all
		assert_equal 1, orders.size
		order = orders[0]

		assert_equal "Dave Thomas", order.name
		assert_equal "123 The Street", order.address
		assert_equal "dave@example.com", order.email
		assert_equal 2, order.payment_type_id

		assert_equal 1, order.line_items.size
		line_item = order.line_items[0]
		assert_equal ruby_book, line_item.product

		# Checking the email is correct
		mail = ActionMailer::Base.deliveries.last
		assert_equal ["dave@example.com"], mail.to
		assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
		assert_equal 'Pragmatic Store Order Confirmation', mail.subject
	end

	# USER STORY 

	# A user goes to the orders page and select an order to ship, click edit and 
	# introduce the shipment date and save the order, an email is sent to the 
	# customer telling the order is on its way.


	def shipping_an_order

		order_to_ship = Order.where(shipping_date: nil).find(:first)

		# A user goes to the orders page
		get "/orders"
		assert_response :success
		assert_template "index"

		# Select an order to ship, click edit
		get "/orders/#{order_to_ship.id}/edit"
		assert_response :success
		assert_template "index"

		# Introduce the shipment date and save the order
		put_via_redirect "/orders/#{order_to_ship.id}", order: { name: "Dave Thomas", address: "123 The Street", email: "dave@example.com", payment_type_id: "2", shipping_date: "2014-04-20" }
		assert_response :success
		assert_template "show"
		order = Order.where(id: order_to_ship.id)
		assert_equal "2014-04-20", order.shipping_date

		# An email is sent to the customer telling the order is on its way
		mail = ActionMailer::Base.deliveries.last
		assert_equal ["dave@example.com"], mail.to
		assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
		assert_equal 'Pragmatic Store Order Shipped', mail.subject

	end

	# USER STORY 

	# A user try to go to a non existing cart and he is re directed to store index with a 
	# error message at the top of the page, and an email is sent to the Administrator 
	# telling the error had occured.

	def non_existing_cart
		# A user goes to the orders page
		get "/carts/243233"

		# He is re directed to store index with a error message at the top of the page
		assert_redirected_to store_url
		assert_equal 'Invalid cart', flash[:notice]

		# An email is sent to the Administrator telling the error had occured.
		mail = ActionMailer::Base.deliveries.last
		assert_equal ["marcotello@grupovidanta.com"], mail.to
		assert_equal 'Depot Application <depot@example.com>', mail[:from].value
		assert_equal 'Pragmatic Store Error Raised', mail.subject

	end

	# USER STORY 

	# A user try to go to a non existing order and he is re directed to store index with a 
	# error message at the top of the page, and an email is sent to the Administrator 
	# telling the error had occured.

	def non_existing_cart
		# A user goes to the orders page
		get "/orders/243233"

		# He is re directed to store index with a error message at the top of the page
		assert_redirected_to store_url
		assert_equal 'Invalid order', flash[:notice]

		# An email is sent to the Administrator telling the error had occured.
		mail = ActionMailer::Base.deliveries.last
		assert_equal ["marcotello@grupovidanta.com"], mail.to
		assert_equal 'Depot Application <depot@example.com>', mail[:from].value
		assert_equal 'Pragmatic Store Error Raised', mail.subject

	end
end
