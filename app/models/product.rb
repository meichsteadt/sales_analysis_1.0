class Product < ApplicationRecord
  has_many :orders
  has_many :sales_numbers

  def total_sales
    sum = 0
    self.orders.each do |order|
      sum += order.total_price
    end
    sum.round(2)
  end

  def sales_ytd
    sum = 0
    begin_date = Date.new(Date.today.year)
    self.orders.where("invoice_date >= ?", begin_date).where("invoice_date <= ?", Date.today).each do |order|
      sum += order.total_price
    end
    sum.round(2)
  end

  def sales_this_month
    sum = 0
    begin_date = Date.new(Date.today.year, Date.today.month)
    self.orders.where("invoice_date >= ?", begin_date).where("invoice_date <= ?", Date.today).each do |order|
      sum += order.total_price
    end
    sum.round(2)
  end

  def self.rank
    products = Product.all.sort_by {|prod| prod.total_sales}.reverse
    products.each_with_index do |product, index|
      product.update(prev_position: product.position)
      product.update(position: index + 1)
    end
  end

  def get_sales_numbers(year, month)
    sales_number = self.sales_numbers.where(year: year, month: month)
  end
end
