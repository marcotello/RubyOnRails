class InsertPaymentTypeIdInOrders < ActiveRecord::Migration
  def up
    #itarating orders
  	Order.all.each do |order|
      #inserting tha payment type id which references the payment type Credit Card
  		order.payment_type_id = 1
      #saving the order
  		order.save!
  	end
  end
  def down
    #itarating orders
  	Order.all.each do |order|
  		#delting the reference
  		order.payment_type_id = nil
      #saving the order
  		order.save!
  	end
  end
end
