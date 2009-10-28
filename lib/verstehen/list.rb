module Verstehen
  class List
    def initialize &expression
      @expression = expression
      @result = []
      @dimensions = []
      @context = Context.new
    end

    def for *symbols
      @dimensions << Dimension.new(symbols)
      symbols.each { |sym| Context.send(:attr_accessor, sym) }
      self
    end

    def in &range
      @dimensions.last.in = range
      self
    end

    def if &condition
      @dimensions.last.if = condition
      self
    end

    def comprehend
      generated = ""
      @dimensions.each_with_index do |dimension, i|
        block_params = dimension.for.collect {|sym| sym.to_s}.join(", ")
        generated << "for #{block_params} in @context.instance_eval(&@dimensions[#{i}].in)\n"
        generated << dimension.for.map {|sym| "@context.#{sym} = #{sym}\n" }.join
        if dimension == @dimensions.last
          if @dimensions[i].if 
            generated << "if @context.instance_eval(&@dimensions[#{i}].if)\n"
          end
          generated << "@result << @context.instance_eval(&@expression)\n"
          if @dimensions[i].if 
            generated << "end\n"
          end
        end
      end
      @dimensions.each_with_index do |dimension, i|
        generated << "end\n"
      end

      #puts generated
      eval generated
      
      @result
    end
  end
end
