require "cart/config"

class Cart
  def self.load(data)
    # return new cart if nil or empty string is given
    return self.new if data.nil? or data.empty?
    data  = data.split(";")
    # compact output array, self.metadata_model.deserialize could return nil
    items = data.map { |item| self.metadata_model.deserialize(item) }.compact
    return self.new(*items)
  end

  attr_reader :items

  def initialize(*items)
    raise ArgumentError unless items.all? { |item| item.is_a?(@config.metadata_model) }
    @items = items
    @config = self.class
    @config.logger.debug("Cart initialized: #{self.inspect}")
  end

  # takes array of products
  def items=(items)
    raise ArgumentError if not items.respond_to?(:each) # not just arrays
    raise ArgumentError if not items.all? { |product| product.kind_of?(@config.metadata_model) }
    @items = items
  end

  def add(params)
    raise ArgumentError unless params.is_a?(Hash)
    new_item = @config.metadata_model.new(params)
    @items.map do |item|
      if item.product.eql?(new_item.product) && item.inverted.eql?(new_item.inverted)
        item.count += new_item.count
        @config.logger.debug("Item #{item.inspect} count was increased to #{item.count} (by #{new_item.count})")
        return # important
      end
    end
    @items.push(new_item)
    @config.logger.debug("Item #{new_item.inspect} was added to cart")
  end

  def remove(params)
    raise ArgumentError unless params.is_a?(Hash)
    item_to_remove = @config.metadata_model.new(params)
    pre = @items.dup
    @items.delete_if do |item|
      item.product.eql?(item_to_remove.product) && item.inverted.eql?(item_to_remove.inverted)
    end
    removed = pre - @items
    @config.logger.debug("Item #{removed.first.inspect} was removed from cart")
  end

  def price
    @items.map { |item| item.price }.inject { |sum, price| sum + price }
  end

  def save
    data = @items.map { |item| item.serialize }.join(";")
    @config.logger.debug("Cart saved: #{data.inspect}")
    return data
  end

  def each(&block)
    @items.each do |item|
      block.call(item)
    end
  end

  def empty?
    @items.empty?
  end

  def count
    @items.length
  end
end
