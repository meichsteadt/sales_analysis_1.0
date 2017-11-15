class Order < ApplicationRecord
  def self.this_year
    Order.where("invoice_date >= ?", Date.today.beginning_of_year)
  end
end
