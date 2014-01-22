class CopyProductsPriceInLineItems < ActiveRecord::Migration
  def up
    #itarating all line_items
  	LineItem.all.each do |line_item|
      #copiyng product price into line_item price
  		line_item.price = line_item.product.price
      #saving line item
  		line_item.save!
  	end
  end
  def down
  	#LineItem.all.each { |line_item| line_item.price = nil }
    #itarating all line_items
  	LineItem.all.each do |line_item|
  		line_item.price = nil
  		line_item.save!
  	end
  end
end
