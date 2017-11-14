class Customer < ApplicationRecord
  has_many :orders
  has_many :sales_numbers
  has_many :customer_comparisons
  has_many :recommended_items
  has_many :customers, :through => :customer_comparisons

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

  def products(time = "year")
    customer_products = {}
    if time == "year"
      orders = self.orders.where("invoice_date >= ?", Date.today.beginning_of_year)
    else
      orders = self.orders.all.sort_by {|order| order.total_price}
    end
    orders.each_with_index do |order, index|
      if !customer_products[order.product_number]
        customer_products[order.product_number] = {}
      end
      if customer_products[order.product_number]["sales_ytd"]
        customer_products[order.product_number]["sales_ytd"] += order.total_price
      else
        customer_products[order.product_number]["sales_ytd"] = order.total_price
      end

      if customer_products[order.product_number]["last_sold"]
        if customer_products[order.product_number]["last_sold"] < order.invoice_date
          customer_products[order.product_number]["last_sold"] = order.invoice_date
        end
      else
        customer_products[order.product_number]["last_sold"] = order.invoice_date
      end

    end
    customer_products.sort_by {|key, val| val["sales_ytd"]}.reverse
  end

  def missing_best_sellers(user)
    total_sales_ytd = user.sales_ytd
    products = self.products.to_h
    mi = {}
    Product.where("position < 100").sort_by {|prod| prod.position}.each do |product|
      if !products[product.number]
        product_sales = product.sales_ytd
        mi[product.number] = {"sales": product_sales, "percentage": product_sales/total_sales_ytd}
      end
    end
    mi.sort_by {|key, val| val["sales"]}
  end

  def self.rank
    customers = Customer.all.sort_by {|customer| customer.sales_ytd}.reverse
    customers.each_with_index do |customer, index|
      customer.update(prev_position: customer.position)
      customer.update(position: index + 1)
    end
  end

  def sim_pearson(customer2)
    start = Time.now
    si={}
    c2_products = customer2.products
    self.products.each do |key, val|
      if c2_products[key]
        si[key] = [val, c2_products[key]]
      end
    end
    n = si.length

    if n == 0; return 0 end

    sum1 = 0
    sum2 = 0
    sum1Sq = 0
    sum2Sq = 0
    pSum = 0
    si.each do |key, val|
      c1_price = val[0]
      c2_price = val[1]
      sum1 += c1_price
      sum2 += c2_price
      sum1Sq += c1_price ** 2
      sum2Sq += c2_price ** 2
      pSum += (c1_price * c2_price)
    end

    num = pSum-(sum1*sum2/n)
    den = Math.sqrt((sum1Sq-(sum1 ** 2)/n)*(sum2Sq-(sum2 ** 2)/n))
    if den == 0; return 0 end

    r = num/den.to_f
  end

  def get_comparison(id)
    self.customer_comparisons.find_by_customer2_id(id)
  end

  def avg_sp
    sum = 0
    self.customer_comparisons.each do |comp|
      sum += comp.sim_pearson
    end
    sum/self.customer_comparisons.length
  end

  def self.top_customers(n)
    Customer.all.sort_by {|c| c.sales_ytd}.reverse.first(n)
  end

  def self.top_percentage(n, user)
    i = 0
    sum = 0
    customers = Customer.all.sort_by {|c| c.sales_ytd}.reverse
    if n < 1
      while(sum < n)
        customer = customers[i]
        sum += customer.sales_ytd / user.sales_ytd
        i += 1
      end
    end
    i
  end

  def sort_sales_numbers
    numbers = []
    today = Date.today
    self.sales_numbers.sort {|a,b| [b.year, b.month] <=> [a.year, a.month]}.each do |number|
      if number.year == today.year
        if number.month <= today.month
          numbers.push(number)
        end
      else
        numbers.push(number)
      end
    end
    numbers
  end

  def prorate(number)
    (1 - ((Date.today.end_of_year - Date.today).to_f / 365)) * number
  end

  def promo_percentage
    sum = 0
    self.orders.where(promo: true).where("invoice_date > ?", Date.today.beginning_of_year).each do |order|
      sum += order.total_price
    end
    sum/self.sales_ytd
  end

  def get_recommended_items
    # start = Time.now
    totals = {}
    sim_sums = {}

    Customer.all.each do |customer|
      if customer.id != self.id
        comparisons = self.customer_comparisons.all
        sim = self.get_comparison(customer.id).sim_pearson
        if sim > 0
          self.missing_items(customer).each do |item|
            totals[item[0]]? totals[item[0]]+= item[1]*sim : totals[item[0]] = item[1]*sim
            sim_sums[item[0]]? sim_sums[item[0]]+=sim : sim_sums[item[0]] = sim
          end
        end
      end
    end

    rankings = []
    totals.each do |item, total|
      if item != "PALLET/"
        rankings.push({item => total/sim_sums[item]})
      end
    end
    rankings.sort_by! {|ranking| ranking.values.first}.reverse!.first(50)
    # Time.now - start
  end

  def missing_items(customer2)
    mi = {}
    c1_products = self.products.to_h
    customer2.products.each do |product|
      if !c1_products[product[0]]
        mi[product[0]] = product[1]["sales_ytd"]
      end
    end
    mi.sort_by {|key, val| val}.reverse
  end

  def update_sales(start_date, end_date)
    sum = 0
    self.orders.where("invoice_date >= ? AND invoice_date <= ?", start_date, end_date).each do |order|
      sum += order.total_price
    end
    self.update(sales_last_year: sum)
  end

  def growth
    return self.sales_ytd - self.sales_last_year
  end
end
