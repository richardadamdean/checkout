require_relative './rule'

class BuyXGetXFree < Rule

  attr_reader :buy_qty, :free_qty

  def initialize(applies_to_sku, buy_qty, free_qty)
    @applies_to_sku = applies_to_sku
    @buy_qty = buy_qty
    @free_qty = free_qty
  end  

  def name
    "Buy #{buy_qty} get #{free_qty} free"
  end

  def apply_to(checkout_items)
    total_required_for_discount = buy_qty + free_qty
    eligible_items(checkout_items).each_slice(total_required_for_discount) do |grouped_items|
      return if grouped_items.size < total_required_for_discount
      grouped_items.each_with_index do |grouped_item, index|
        grouped_item.discounted = true
        grouped_item.discount_rule = self
        grouped_item.price = 0 if index >= buy_qty
      end
    end
  end
end