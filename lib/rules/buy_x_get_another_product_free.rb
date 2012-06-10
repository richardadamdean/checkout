require_relative './rule'

class BuyXGetAnotherProductFree < Rule

  attr_reader :buy_qty, :free_sku

  def initialize(applies_to_sku, buy_qty, free_sku, free_item_name='')
    @applies_to_sku = applies_to_sku
    @buy_qty = buy_qty
    @free_sku = free_sku
    @free_item_name = free_item_name
  end  

  def name
    "Buy #{buy_qty} get a free #{free_sku}"
  end

  def apply_to(checkout_items)
    eligible_items(checkout_items).each_slice(buy_qty) do |grouped_items|
      return if grouped_items.size < buy_qty
      grouped_items.each_with_index do |grouped_item, index|
        grouped_item.discounted = true
        grouped_item.discount_rule = self
      end

      # add a new CheckoutItem
      free_item = CheckoutItem.new(@free_sku, 0, @free_item_name)
      free_item.discounted = true
      free_item.discount_rule = self
      checkout_items << free_item
    end    
  end
end