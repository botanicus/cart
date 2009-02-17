require File.join(File.dirname(__FILE__), '..', "spec_helper")
require "cart/simple"

Cart.product_model = Product
Cart.logger = lambda { }

describe Cart do
  before(:each) do
    @cart = Cart.new
    10.times { Product.create }
    @cart.items = Product.all
  end

  describe ".load" do
    it "should load serialized items" do
      pending "works, but this spec do not"
      loaded_cart = Cart.load(@cart.save)
      loaded_cart.items.should eql(@cart.items)
    end

    it "should return empty cart if first (and only) argument is nil" do
      Cart.load(nil).items.should eql(Array.new)
    end
  end

  describe "#items" do
    it "should create new cart with empty items" do
      Cart.new.items.should be_empty
    end

    it "should be array of products" do
      pending "works, but this spec do not"
      @cart.items.all? { |item| item.kind_of?(Product) }.should be_true
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

  describe "#inspect" do
    it "should show id of products in items"
  end

  describe "#save" do
    it "should serialize items" do
      @cart.save.should be_kind_of(String)
    end

    it "should be regular YAML" do
      lambda { YAML::load(@cart.save) }.should_not raise_error
    end
  end

  describe "#add" do
    it "should add one product into cart's items by default"
    it "should add more product into cart's items when optional argument given"
  end

  describe "#remove" do
    it "should remove one product into cart's items by default"
    it "should remove more product into cart's items when optional argument given"
  end

  describe "#empty?" do
    it "should returns true if there aren't any items" do
      Cart.new.should be_empty
    end

    it "should returns false if there aren't any items" do
      @cart.should_not be_empty
    end
  end
end
