class RecommendedItem < ApplicationRecord
  def self.get_item
    Customer.where("position <= 61").each do |customer|
      customer.get_recommended_items.each do |item|
        key = item.keys[0]
        value = item[key]
        product_id = Product.find_by_number(key).id
        customer.recommended_items.create(product_id: product_id, product_number: key, projected_sales: value)
      end
    end
  end
end
