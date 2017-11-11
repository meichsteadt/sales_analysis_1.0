class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def total_sales_ytd
    sum = 0
    Customer.all.each do |customer|
      sum += customer.sales_ytd
    end
    sum
  end
end
