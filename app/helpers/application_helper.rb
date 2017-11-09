module ApplicationHelper
  def get_customer_products
    Customer.all.each do |customer|
      Product.all.each do |product|
        sum = 0
        customer.orders.where(product_id: product.id).each do |order|
          sum+= order.total_price
        end
        customer.products.create(total_sales: sum)
      end
    end
  end
end

customer = Customer.first
customer_products = {}
Product.all.each do |product|
  sum = 0
  customer.orders.where(product_id: product.id).each do |order|
    sum+= order.total_price
  end
  customer_products[product.number] = sum.round(2)
end

start = Time.now
customer_products = {}
customer.orders.all.each do |order|
  if customer_products[order.product_id]
    customer_products[order.product_id] += order.total_price
  else
    customer_products[order.product_id] = order.total_price
  end
end
end_time = Time.now
