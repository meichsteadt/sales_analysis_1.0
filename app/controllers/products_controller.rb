class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  def index
    respond_to do |format|
      format.json {render json: products_with_totals}
    end
  end

  def show
    respond_to do |format|
      format.json {render json: {"product": @product, "last_sold": @product.last_sold.invoice_date, "sales_numbers": @product.sales_numbers}}
    end
  end
private
  def set_product
    @product = Product.find(params[:id])
  end

  def products_with_totals
    sorted_products = []
    products = []
    cumm_percentage = 0
    total_sales_ytd = Product.first.total_sales_ytd(1)
    if params[:limit]
      products = Product.where("position <= ?", params[:limit])
    else
      products = Product.all
    end
    products = sort_products(products, params[:sort_by], params[:sort_order])
    products.each do |product|
      cumm_percentage += product.sales_ytd/total_sales_ytd
      sorted_products.push({product: product, cumm_percentage: cumm_percentage, growth: product.growth})
    end
    sorted_products
  end

  def sort_products(products, sort_by = "position", sort_order = "desc")
    returned_products = nil
    if Product.column_names.include?(sort_by)
      returned_products = products.sort_by {|product| product[sort_by]}
    elsif sort_by == "growth"
      returned_products = products.sort_by {|product| product.growth}
    else
      returned_products = products
    end
    if sort_order == "desc"
      returned_products.reverse
    else
      returned_products
    end
  end
end
