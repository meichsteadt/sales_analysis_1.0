class Customer < ApplicationRecord
  has_many :orders
  has_many :sales_numbers

  def total_sales
    sum = 0
    self.sales_numbers.each do |order|
      sum += order.sales
    end
    sum.round(2)
  end

  def sales_ytd
    sum = 0
    self.sales_numbers.where(year: Date.today.year).each do |order|
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

  def self.rank
    customers = Customer.all.sort_by {|customer| customer.total_sales}.reverse
    customers.each_with_index do |customer, index|
      customer.update(prev_position: customer.position)
      customer.update(position: index + 1)
    end
  end


end
