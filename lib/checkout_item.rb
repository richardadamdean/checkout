class CheckoutItem
  
  attr_reader :sku, :price, :name
  attr_accessor :price, :discounted, :discount_rule

  def initialize(sku, price, name='')
    @sku = sku
    @price = price
    @name = name
    @discounted = false
  end

  def price
    @price / 100.0
  end
end

