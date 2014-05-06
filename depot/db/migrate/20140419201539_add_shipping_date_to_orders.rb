class AddShippingDateToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :shipping_date, :date
  end
end
