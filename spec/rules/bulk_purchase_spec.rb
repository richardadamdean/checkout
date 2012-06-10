require_relative '../../lib/rules/bulk_purchase'
require_relative '../../lib/checkout_item'

describe BulkPurchase do
  
  context :apply do
  
    context 'when the rule eligibility conditions are met' do

      before :each do 
        @rule = BulkPurchase.new 'sku', 2, 1500
        @items = [
          CheckoutItem.new('sku', 2000),
          CheckoutItem.new('sku', 2000)
        ]
        
        previously_discounted = CheckoutItem.new('sku', 15.0)
        previously_discounted.discount_rule = @rule
        previously_discounted.discounted = true
        @items << previously_discounted

        @rule.apply_to @items
      end

      it 'should mark all items involved in the discount as being discounted' do
        @items.map(&:discounted).should == [true, true, true]
      end

      it 'should set each item to have the new price' do
        @items.map(&:price).should == [15.0, 15.0, 15.0]
      end

      it 'should assign the rule for future reference' do
        @items.map(&:discount_rule).should == [@rule, @rule, @rule]
      end

    end

    context 'when the rules following eligibility requirements are not met' do

      it 'should not apply the rule if no skus match' do
        rule = BulkPurchase.new 'sku', 3, 1000
        items = [CheckoutItem.new('sku1', 100)]
        rule.apply_to items
        items.first.discounted.should be_false
      end

      it 'should not apply the rule if the buy quantity is not matched' do
        rule = BulkPurchase.new 'sku', 3, 1000
        items = [
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku2', 100)
        ]
        rule.apply_to items
        items.map(&:discounted).should == [false, false, false, false]
      end

      it 'should not apply the rule if matching items have already been discounted' do
        rule = BulkPurchase.new 'sku', 2, 1000
        items = [
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku', 100),
          CheckoutItem.new('sku', 100)
        ]
        items.first.discounted = true
        rule.apply_to items
        items.map(&:discounted).should == [true, false, false]
      end

    end

  end

  context :name do

    it 'should return the correct name' do
      BulkPurchase.new('', 4, 2000).name.should == "Buy more than 4 and pay $20 per item"
    end

  end

end
