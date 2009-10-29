module Kernel
  def list &block; Verstehen::List.new &block; end
end

module Verstehen
  Dimension = Struct.new(:for, :in, :if)
  
  class Context; end
end

require 'verstehen/list'
