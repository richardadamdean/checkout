require_relative '../../lib/rules/buy_x_get_x_free'
require_relative '../../lib/checkout_item'

describe BuyXGetXFree do
  
  context :apply do
  
    context 'when the rule eligibility conditions are met' do

      before :each do 
        @rule = BuyXGetXFree.new 'sku', 2, 1
        @items = [
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku', 100)
        ]
        @rule.apply_to @items
      end

      it 'should mark all items involved in the discount as being discounted' do
        @items.map(&:discounted).should == [true, true, true]
      end

      it 'should set the free item to have zero cost' do
        @items.last.price.should == 0
      end

      it 'should assign the rule for future reference' do
        @items.map(&:discount_rule).should == [@rule, @rule, @rule]
      end

    end

    context 'when the rules following eligibility requirements are not met' do

      it 'should not apply the rule if no skus match' do
        rule = BuyXGetXFree.new 'sku', 2, 1
        items = [CheckoutItem.new('sku1', 100)]
        rule.apply_to items
        items.first.discounted.should be_false
      end

      it 'should not apply the rule if the buy quantity is not matched' do
        rule = BuyXGetXFree.new 'sku', 2, 1
        items = [
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku2', 100)
        ]
        rule.apply_to items
        items.map(&:discounted).should == [false, false]
      end

      it 'should not apply the rule if the buy quantity is matched but the free quantity is not' do
        rule = BuyXGetXFree.new 'sku', 2, 1
        items = [
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku2', 100)
        ]
        rule.apply_to items
        items.map(&:discounted).should == [false, false, false]
      end

      it 'should not apply the rule if matching items have already been discounted' do
        rule = BuyXGetXFree.new 'sku', 2, 1
        items = [
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku1', 100)
        ]
        items.first.discounted = true
        rule.apply_to items
        items.map(&:discounted).should == [true, false, false]
      end

    end

  end

  context :name do

    it 'should return the correct name' do
      BuyXGetXFree.new('', 2, 1).name.should == "Buy 2 get 1 free"
    end

  end

end
