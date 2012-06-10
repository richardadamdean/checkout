require_relative '../lib/checkout'

describe Checkout do
  
  context :scan do

    it 'should add the new item to the cart' do
      checkout = Checkout.new
      checkout.scan :sku => 'sku1', :price => 2000
      checkout.items.first.sku.should == 'sku1'
    end
    
    it 'should apply the given rules to the set of items' do
      rule = mock 'rule'
      rule.should_receive :apply_to
      checkout = Checkout.new [rule]
      checkout.scan :sku => 'sku1', :price => 2000
    end

  end

  context :total do

    it 'should return the summed price of the cart items' do
      checkout = Checkout.new
      checkout.instance_variable_set(:@items, [mock(:price => 1000), mock(:price => 2000)])
      checkout.total.should == 3000
    end

  end

end

