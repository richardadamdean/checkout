require_relative '../../lib/rules/buy_x_get_another_product_free'
require_relative '../../lib/checkout_item'

describe BuyXGetAnotherProductFree do
  
  context :apply do
  
    context 'when the rule eligibility conditions are met' do

      before :each do 
        @rule = BuyXGetAnotherProductFree.new 'sku', 2, 'sku2'
        @items = [
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku', 100)
        ]
        @rule.apply_to @items
      end

      it 'should add a new line item with the free item sku' do
        @items.last.sku.should == 'sku2'
      end

      it 'should set the free item to have zero cost' do
        @items.last.price.should == 0
      end

      it 'should mark all items involved in the discount as being discounted' do
        @items.map(&:discounted).should == [true, true, true]
      end

      it 'should assign the rule for future reference' do
        @items.map(&:discount_rule).should == [@rule, @rule, @rule]
      end

    end

    context 'when the rules following eligibility requirements are not met' do

      it 'should not apply the rule if no skus match' do
        rule = BuyXGetAnotherProductFree.new 'sku', 2, 'sku2'
        items = [CheckoutItem.new('sku1', 100)]
        rule.apply_to items
        items.first.discounted.should be_false
      end

      it 'should not apply the rule if the buy quantity is not matched' do
        rule = BuyXGetAnotherProductFree.new 'sku', 2, 'sku2'
        items = [
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku2', 100)
        ]
        rule.apply_to items
        items.map(&:discounted).should == [false, false]
      end

      it 'should not apply the rule if matching items have already been discounted' do
        rule = BuyXGetAnotherProductFree.new 'sku', 2, 'sku2'
        items = [
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku', 100)
        ]
        items.first.discounted = true
        rule.apply_to items
        items.map(&:discounted).should == [true, false]
        items.size.should == 2
      end

    end

  end

  context :name do

    it 'should return the correct name' do
      BuyXGetAnotherProductFree.new('', 2, 'sku2').name.should == "Buy 2 get a free sku2"
    end

  end

end
