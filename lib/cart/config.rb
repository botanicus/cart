require "cart/logger_stub"

class NotInitializedError < StandardError ; end

class Cart
  class << self
    attr_writer :product_model, :metadata_model
    def product_model
      @product_model || raise(NotInitializedError)
    end

    def metadata_model
      @metadata_model || raise(NotInitializedError)
    end

    def logger
      @logger || raise(NotInitializedError)
    end

    def logger=(logger)
      if logger.respond_to?(:to_proc)
        @logger = LoggerStub.new(logger)
      elsif logger.respond_to?(:debug)
        @logger = logger
      else
        raise "Given logger must be callable object (Proc or Method for example) or an object with debug method."
      end
    end
  end
end
