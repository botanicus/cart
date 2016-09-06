# encoding: utf-8

require "ostruct"
require "cart/config"

class CartItem < OpenStruct
  undef :id
end

# NOTE: all public methods works with products, not with their IDs
class Cart
  def self.load(data)
    cart = Cart.new
    unless data.nil?
      data = YAML::load(data)
      cart.items = data.map { |id| @config.product_model.get(id) }
    end
    return cart
  end

  # returns array of products
  def items
    @items.map { |item| @config.product_model.get(item) }
  end

  def inspect
    %{<cart @items=#{@config.product_model}#{@items.map { |i| i.id }.inspect}>}
  end

  # takes array of products
  def items=(products)
    raise ArgumentError if not products.respond_to?(:each) # not just arrays
    raise ArgumentError if not products.all? { |product| product.kind_of?(@config.product_model) }
    @items = products.to_a
  end

  def initialize
    @items = Array.new
    @config = self.class
  end

  def save
    @items.map { |product| product.id }.to_yaml
  end

  def add(product, count = 1)
    raise ArgumentError unless product.kind_of(@config.product_model)
    if item = find(product)
      item.count += count
    else
      struct = CartItem.new
      struct.id = id
      struct.count = count
      @items.push(struct)
    end
  end

  # remove all products with id 1
  # cart.remove(1)
  # remove 2 products with id 1
  # cart.remove(1, 2)
  def remove(product, count = nil)
    if item = find(product)
      if count.nil? || item.count <= count
        @items.delete(item)
      elsif item.count > count
        item.count = (item.count - count)
      end
    end
  end

  def empty?
    @items.empty?
  end

  protected
  def find(product)
    @items.find { |item| item.id.eql?(product.id) }
  end
end
