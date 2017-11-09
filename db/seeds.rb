# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def get_sales_numbers(year, month, object)
  sum = 0
  begin_date = Date.new(year, month)
  end_date = Date.new(year, month).end_of_month
  object.orders.where("invoice_date >= ?", begin_date).where("invoice_date <= ?", end_date).each do |order|
  puts order.total_price
    sum += order.total_price
  end
  object.sales_numbers.create(month: month, year: year, sales: sum.round(2))
end

7.times do |time|
  file = File.read("sales_data_page#{time + 1}.json")
  json = eval(file)

  json[:items].each do |item|
    if item[:model] && item[:customer]
      customer = nil
      product = nil
      promo = false
      invoice_date = nil
      if !Customer.find_by_name_id(item[:customer])
        name = item[:customerName].gsub("'", "")
        customer = Customer.new(name: name, state: item[:state], name_id: item[:customer])
        customer.save
      else
        customer = Customer.find_by_name_id(item[:customer])
      end

      if !Product.find_by_number(item[:model])
        product = Product.new(number: item[:model])
        product.save
      else
        product = Product.find_by_number(item[:model])
      end

      if item[:priceName] != "Unit Price"
        promo = true
      end

      if item[:invoiceDate]
        invoice_date = item[:invoiceDate].to_date
      end

      customer.orders.create(product_id: product.id, invoice_id: item[:invoice], invoice_date: invoice_date, quantity: item[:totalQty], unit_price: item[:unitPrice], total_price: item[:totalPrice], promo: promo)
    end
  end
end

Product.all.each do |object|
  years = [15,16,17]
  12.times do |month|
    years.each do |year|
      get_sales_numbers(2000 + year, month + 1, object)
    end
  end
end

Customer.all.each do |object|
  years = [15,16,17]
  12.times do |month|
    years.each do |year|
      get_sales_numbers(2000 + year, month + 1, object)
    end
  end
end
