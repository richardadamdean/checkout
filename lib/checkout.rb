require File.dirname(__FILE__) + '/checkout_item'
Dir[File.dirname(__FILE__) + '/rules/*.rb'].each {|file| require file }

class Checkout

  attr_reader :items

  def initialize(pricing_rules=[])
    @items = []
    @pricing_rules = pricing_rules
  end

  # pricing_rules are applied in the order they're added, 
  # items are never double-discounted
  def scan(item)
    @items << CheckoutItem.new(item[:sku], item[:price], item[:name])
    @pricing_rules.each { |rule| rule.apply_to @items }
  end

  def total
    @items.inject(0){|sum,item| sum + item.price }
  end

end