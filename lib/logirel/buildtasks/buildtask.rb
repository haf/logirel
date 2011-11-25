
module Logirel

  class BuildTask

    private
      @symbol
      @children

    public
    def initialize symbol, children = []
      @symbol = symbol
      @children = children
    end

    def children
      @children ||= []
    end

    def to_s
      "BuildTask(#{@symbol.to_s})"
    end
  end

end