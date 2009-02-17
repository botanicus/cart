require File.join(File.dirname(__FILE__), '..', "spec_helper")
require "cart/logger_stub"

describe LoggerStub do
  it "should works with lambdas" do
    # just return the message
    proc = lambda { |message| message }
    logger = LoggerStub.new(proc)
    logger.debug("Hey, it works!").should eql("Hey, it works!")
  end

  it "should works with methods" do
    # just return the message
    def just_return(message) ; message ; end
    logger = LoggerStub.new(method(:just_return))
    logger.debug("Hey, it works!").should eql("Hey, it works!")
  end
end
