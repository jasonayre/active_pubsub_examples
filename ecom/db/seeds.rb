# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'pry'
{
  :imac => 2000,
  :iphone => 600,
  :android => 400,
  :xbox => 500,
  :tv => 800

}.each_pair do |k,v|
  Product.create!(:name => k.to_s, :price => v)

end

Customer.create(:name => "Steve Jobs")
Customer.create(:name => "Tom Sykowski")

puts "Making sales"
customers = Customer.all.to_a
products = Product.all.to_a
10000.times do |i|
  product = products[rand(products.size - 1)]
  customer = customers[rand(customers.size - 1)]



  random_discount = (1..50).to_a[rand(50)]

  puts product.inspect
  puts customer.inspect
  puts random_discount.inspect


  sale = ::Sale.create!({
    :product_id => product.id,
    :customer_id => customer.id,
    :price => product.price - random_discount
  })

  puts "made sale! #{sale.id}"
end
