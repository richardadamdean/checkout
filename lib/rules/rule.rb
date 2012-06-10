class Rule

  attr_reader :applies_to_sku

  def applies_to?(checkout_item)
    applies_to_sku == checkout_item.sku
  end

  def apply_to(checkout_items) ; end

  def name() 
    "" 
  end

protected 

  def eligible_items(checkout_items)
    checkout_items.select{|item| self.applies_to?(item)  && !item.discounted}
  end

end