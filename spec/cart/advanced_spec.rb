require File.join(File.dirname(__FILE__), '..', "spec_helper")
require "cart/advanced"

Cart.metadata_model = OrderItem
Cart.logger = lambda { }

describe Cart do
  before(:each) do
    items = 10.of { OrderItem.make(:saved_products) }
    # we need to save all the products otherwise we can't
    # serialize the cart (we need to know product ID)
    @cart = Cart.new(*items)
  end

  describe ".load" do
    it "should load serialized items" do
      loaded_cart = Cart.load(@cart.save)
      loaded_cart.items.should eql(@cart.items)
    end

    it "should return empty cart if first (and only) argument is nil" do
      Cart.load(nil).items.should eql(Array.new)
    end

    it "should return empty cart if first (and only) argument is empty string" do
      Cart.load(String.new).items.should eql(Array.new)
    end
  end

  describe "#items" do
    it "should create new cart with empty items" do
      Cart.new.items.should be_empty
    end

    it "should be array of order items" do
      @cart.items.all? { |item| item.kind_of?(OrderItem) }.should be_true
    end
  end

  describe "#items=" do
    it "should raise ArgumentError if first (and only) argument isn't collection" do
      lambda { @cart.items = 1 }.should raise_error(ArgumentError)
    end

    it "should raise ArgumentError if some of items isn't integer" do
      lambda { @cart.items = [1, "foo"] }.should raise_error(ArgumentError)
    end
  end

  describe "#save" do
    it "should serialize items" do
      @cart.save.should be_kind_of(String)
    end

    it "should be in valid format" do
      pattern = 10.of {'\d+,\d,\d+'}.join(";")
      @cart.save.should match(/^#{pattern}$/)
    end
  end

  describe "#add" do
    before do
      # NOTE: when inspecting @item, u can see that
      # product_id is nil althought we set the product.
      # It is OK, product_id is set when product is saving
      @item = OrderItem.make
      @cart = Cart.new(@item)
      @item.product.category = Category.generate(:standalone)
      @item.product.save
      @params = {:product => @item.product, :inverted => @item.inverted}
    end

    it "should add one order item into cart's items by default" do
      lambda { @cart.add(@params) }.should_not change { @cart.count }
    end

    it "should increase count of order item if product and inverted are same" do
      item = @cart.items.find { |item| item.product.eql?(@item.product) }
      lambda { @cart.add(@params) }.should change { item.count }.by(1)
    end

    it "should add more order items into cart's items if product is different" do
      another = Product.generate(:standalone)
      params = @params.merge(:product => another)
      lambda { @cart.add(params) }.should change { @cart.count }.by(1)
    end

    it "should add more order items into cart's items if product is same, but inverted is different" do
      params = @params.merge(:inverted => (not @item.inverted))
      lambda { @cart.add(params) }.should change { @cart.count }.by(1)
    end

    it "should raise error if params are not hash" do
      lambda { @cart.add(@item) }.should raise_error(ArgumentError)
    end
  end

  describe "#remove" do
    before do
      # NOTE: when inspecting @item, u can see that
      # product_id is nil althought we set the product.
      # It is OK, product_id is set when product is saving
      @item = OrderItem.make
      @cart = Cart.new(@item)
      @item.product.category = Category.generate(:standalone)
      @item.product.save
      @params = {:product => @item.product, :inverted => @item.inverted}
    end

    it "should remove order item with coresponding product and inverted options from cart's items" do
      lambda { @cart.remove(@params) }.should change { @cart.count }.by(-1)
    end

    it "should raise error if params are not hash" do
      lambda { @cart.remove(@item) }.should raise_error(ArgumentError)
    end
  end

  describe "#empty?" do
    it "should returns true if there aren't any items" do
      Cart.new.should be_empty
    end

    it "should returns false if there aren't any items" do
      @cart.should_not be_empty
    end
  end

  describe "#count" do
    it "should returns count of items" do
      Cart.new.count.should eql(0)
      @cart.count.should eql(10)
    end
  end
end
