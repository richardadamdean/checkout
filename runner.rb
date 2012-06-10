require_relative './lib/checkout'

# create some skus
ipd = {:sku => 'ipd', :name => 'Super iPad', :price => 54999 }
mbp = {:sku => 'mbp', :name => 'MacBook Pro', :price => 139999}
atv = {:sku => 'atv', :name => 'Apple TV', :price => 10950 }
vga = {:sku => 'vga', :name => 'Vga adapter', :price => 3000  }

# create our rules
rules = [
  BulkPurchase.new('ipd', 4, 49999),
  BuyXGetAnotherProductFree.new('mbp', 1, 'vga', vga[:name]),
  BuyXGetXFree.new('atv', 2, 1)
]

ci = Checkout.new rules
[atv, atv, atv, vga].each {|item| ci.scan item}
ci.items.each{|item| puts "#{item.name} - $#{item.price}"}
puts '-'*40
puts "Cart Total: $#{ci.total}"
puts '-'*40
puts

ci = Checkout.new rules
[atv, ipd, ipd, atv, ipd, ipd, ipd].each {|item| ci.scan item}
ci.items.each{|item| puts "#{item.name} - $#{item.price}"}
puts '-'*40
puts "Cart Total: $#{ci.total}"
puts '-'*40
puts

ci = Checkout.new rules
[mbp, vga, ipd].each {|item| ci.scan item}
ci.items.each{|item| puts "#{item.name} - $#{item.price}"}
puts '-'*40
puts "Cart Total: $#{ci.total}"
puts '-'*40
puts