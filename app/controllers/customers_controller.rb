class CustomersController < ApplicationController
  before_action :set_cusomter, only: [:show]
  def index
    respond_to do |format|
      format.json {render json: customers_with_totals}
    end
  end

  def show
    respond_to do |format|
      format.json {render json: {"customer": @customer, "sales_numbers": @customer.sales_numbers}}
    end
  end
private
  def set_cusomter
    @customer = Customer.find(params[:id])
  end

  def customers_with_totals
    customers = []
    if params[:limit]
      Customer.where("position <= ?", params[:limit].to_i).sort_by {|c| c.position }.each do |customer|
        customers.push({customer: customer, sales_ytd: customer.sales_ytd})
      end
    else
      Customer.all.sort_by {|c| c.position }.each do |customer|
        customers.push({customer: customer, sales_ytd: customer.sales_ytd})
      end
    end
    customers
  end
end
