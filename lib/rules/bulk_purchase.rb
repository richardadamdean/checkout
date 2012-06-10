require_relative './rule'

class BulkPurchase < Rule

  attr_reader :buy_qty, :discount_price

  def initialize(applies_to_sku, buy_qty, discount_price)
    @applies_to_sku = applies_to_sku
    @buy_qty = buy_qty
    @discount_price = discount_price
  end  

  def name
    "Buy more than #{buy_qty} and pay $#{discount_price/100} per item"
  end

  def apply_to(checkout_items)
    eligible_items = eligible_items checkout_items
    if eligible_items.size > buy_qty
      eligible_items.each do |item|
        item.price = discount_price
        item.discounted = true
        item.discount_rule = self
      end
    end
  end

private 

  # provide an overriden funciton to find items here, because we want to include 
  # items that have already been discounted by this discount before 
  def eligible_items(checkout_items)
    checkout_items.select do |item| 
      self.applies_to?(item)  && (!item.discounted || (item.discounted && item.discount_rule == self))
    end
  end

end