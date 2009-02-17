class Product
  include DataMapper::Resource
  property :id, Serial
end

class OrderItem
  include DataMapper::Resource
  property :id, Serial
  property :size, Enum["10x20", "20x30", "25x40"]
  property :inverted, Boolean

  def serialize
  end

  class << self
    def restore(data)
    end

    def fixture(params = Hash.new)
    end
  end
end
