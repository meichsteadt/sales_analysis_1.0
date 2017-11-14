class Product < ApplicationRecord
  has_many :orders
  has_many :sales_numbers
  has_and_belongs_to_many :customers

  def total_sales
    sum = 0
    self.sales_numbers.each do |order|
      sum += order.sales
    end
    sum.round(2)
  end

  def sales_this_month
    sum = 0
    self.sales_numbers.where(month: Date.today.month, year: Date.today.year).each do |order|
      sum += order.sales
    end
    sum.round(2)
  end

  def get_sales_numbers(year = nil, month = nil)
    sum = 0
    if month && year
      self.sales_numbers.where(month: month, year: year).each do |order|
        sum += order.sales
      end
    elsif month
      self.sales_numbers.where(month: month).each do |order|
        sum += order.sales
      end
    else
      self.sales_numbers.where(year: year).each do |order|
        sum += order.sales
      end
    end
    sum
  end

  def growth
    return self.sales_ytd - self.sales_last_year
  end

  def get_last_sold(customer = nil)
    if customer
      customer.orders.where.not(invoice_date: nil).where(product_id: self.id).order(invoice_date: :desc).first.invoice_date
    else
      self.orders.where.not(invoice_date: nil).order(invoice_date: :desc).first.invoice_date
    end
  end

  def self.rank
    products = Product.all.sort_by {|product| product.sales_ytd}.reverse
    products.each_with_index do |product, index|
      product.update(prev_position: product.position)
      product.update(position: index + 1)
    end
  end

  def update_sales(start_date, end_date)
    sum = 0
    self.orders.where("invoice_date >= ? AND invoice_date <= ?", start_date, end_date).each do |order|
      sum += order.total_price
    end
    self.update(sales_last_year: sum)
  end
end
