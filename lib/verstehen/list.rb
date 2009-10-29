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
      eval self.to_s
      @result # populated from eval
    end

    def to_s(depth = 0, indent = 0)

      if depth == @dimensions.length # inner most block
        tab(indent) + "@result << @context.instance_eval(&@expression)\n"
      else
        opening = ""
        closing = ""

        block_params = @dimensions[depth].for.collect { |sym| sym.to_s }.join(", ")
        opening << tab(indent) + "for #{block_params} in @context.instance_eval(&@dimensions[#{depth}].in)\n" 
        opening << @dimensions[depth].for.map {|sym| tab(indent + 1) + "@context.#{sym} = #{sym}\n" }.join
        closing << tab(indent) + "end\n"
        if @dimensions[depth].if
          indent += 1
          opening << tab(indent) + "if @context.instance_eval(&@dimensions[#{depth}].if)\n"
          closing =  tab(indent) + "end\n" << closing
        end
        opening + to_s(depth + 1, indent + 1) + closing
      end
    end

    def tab(indent)
      "  " * indent
    end
  end
end
