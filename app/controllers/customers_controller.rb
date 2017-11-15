class CustomersController < ApplicationController
  before_action :set_cusomter, only: [:show]
  def index
    @customers = Customer.all
    if params[:sort_by]
      @customers = sort_customers(params[:sort_by], params[:sort_order])
    end
    respond_to do |format|
      format.json {render json: @customers}
    end
  end

  def show
    respond_to do |format|
      format.json {render json: {
        "customer": @customer,
        "sales_numbers": @customer.sort_sales_numbers,
        "products": @customer.products.first(50),
        "missing_best_sellers": @customer.missing_best_sellers(User.first),
        "sales_ytd": @customer.sales_ytd,
        "promo_percentage": @customer.promo_percentage,
        "recommended_items": @customer.recommended_items,
        "missing_growth_items": @customer.missing_growth_items
      }}
    end
  end
private
  def set_cusomter
    @customer = Customer.find(params[:id])
  end

  def sort_customers(sort_by, sort_order = false)
    customers = nil
    if Customer.column_names.include?(sort_by)
      customers = Customer.all.sort_by {|customer| customer[sort_by]}
    elsif sort_by == "growth"
      customers = Customer.all.sort_by {|customer| customer.growth}
    else
      customers = Customer.all
    end
    if sort_order == "desc"
      customers.reverse
    else
      customers
    end
  end
end
