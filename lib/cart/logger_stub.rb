# This class is just a wrapper which give you 
# chance to give callable object instead of logger.
# See README file for more informations.

# LoggerStub.new lambda { |message| puts message }
# LoggerStub.new(method(:puts))
class LoggerStub
  def initialize(callable)
    @callable = callable
  end

  def debug(message)
    @callable.call(message)
  end
end
