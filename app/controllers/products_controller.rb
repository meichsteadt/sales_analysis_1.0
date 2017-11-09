class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  def index
    respond_to do |format|
      format.json {render json: products_with_totals}
    end
  end

  def show
    respond_to do |format|
      format.json {render json: {"product": @product, "sales_numbers": @product.sales_numbers}}
    end
  end
private
  def set_product
    @product = Product.find(params[:id])
  end

  def products_with_totals
    products = []
    if params[:limit]
      Product.where("position <= ?", params[:limit]).sort_by {|prod| prod.position}.each do |product|
        products.push({product: product, sales_ytd: product.sales_ytd})
      end
    else
      Product.all.each.sort_by! {|c| c[:sales_ytd]}.reverse do |product|
        products.push({product: product, sales_ytd: product.sales_ytd})
      end
    end
    products
  end
end
