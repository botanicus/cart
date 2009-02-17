require File.join(File.dirname(__FILE__), '..', "spec_helper")
require "cart/config"

class Logger
  def debug(message)
    puts(message)
  end
end

describe Cart do
  describe "#product_model & #product_model=" do
    it "should returns given model if configured" do
      Cart.product_model = Product
      Cart.product_model.should eql(Product)
    end

    it "should raise an exception unless configured" do
      Cart.product_model = nil
      lambda { Cart.product_model }.should raise_error(NotInitializedError)
    end
  end

  describe "#metadata_model & #metadata_model=" do
    it "should returns given model if configured" do
      Cart.metadata_model = Product
      Cart.metadata_model.should eql(Product)
    end

    it "should raise an exception unless configured" do
      Cart.metadata_model = nil
      lambda { Cart.metadata_model }.should raise_error(NotInitializedError)
    end
  end

  describe "#logger & #logger=" do
    it "should works with lambdas" do
      Cart.logger = Logger.new
      Cart.logger.should be_kind_of(Logger)
    end

    it "should raise exception when object is not callable and not respond to debug method" do
      lambda { Cart.logger = Class.new }.should raise_error
    end

    it "should works with lambdas" do
      Cart.logger = lambda { |msg| puts(msg) }
      Cart.logger.should be_kind_of(LoggerStub)
    end

    it "should works with references to method" do
      Cart.logger = method(:puts)
      Cart.logger.should be_kind_of(LoggerStub)
    end
  end
end
