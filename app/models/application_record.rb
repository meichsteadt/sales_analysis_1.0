class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def total_sales_ytd(id)
    User.find(id).sales_ytd
  end
end
