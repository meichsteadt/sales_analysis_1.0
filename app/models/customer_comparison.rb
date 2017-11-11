class CustomerComparison < ApplicationRecord
  belongs_to :customer
  def self.get_comparisons
    Customer.all.each do |customer|
      Customer.all.each do |customer2|
        if customer.customer_comparisons.where(customer2_id: customer2.id).length == 0 && customer.id != customer2.id
          sim_pearson = customer.sim_pearson(customer2)
          customer.customer_comparisons.create(customer2_id: customer2.id, customer2_name: customer2.name, sim_pearson: sim_pearson)
          customer2.customer_comparisons.create(customer2_id: customer.id, customer2_name: customer.name, sim_pearson: sim_pearson)
        end
      end
    end
  end
end
