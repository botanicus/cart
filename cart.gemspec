begin
  require "rubygems/specification"
rescue SecurityError
  # http://gems.github.com
end

VERSION  = "0.0.1"
SPECIFICATION = ::Gem::Specification.new do |s|
  s.name = "cart"
  s.version = VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/cart"
  s.summary = "Cart is framework agnostic solution for shopping cart."
  s.description = "Cart is framework agnostic solution for shopping cart. There are two existing imlementations. First is *Cart::Simple* which is just basic cart which can store only ID of products without any metadata. The second is *Cart::Advanced* and it is good when you have not just product, but also some metadata as size or color of product etc."
  s.cert_chain = nil
  s.email = ["knava.bestvinensis", "gmail.com"].join("@")
  s.files = Dir.glob("**/*") - Dir.glob("pkg/*")
  s.require_paths = ["lib"]
  # s.required_ruby_version = ::Gem::Requirement.new(">= 1.9.1")
  # s.rubyforge_project = "cart"
end
