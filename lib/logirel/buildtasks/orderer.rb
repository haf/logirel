require 'tsort'

module Logirel
  module BuildTasks

    class Orderer
      def initialize
        @dep = {}
        @dep.default = []
      end

      def add outputs, inputs, task
        triple = [outputs, inputs, task]
        outputs.each { |o| @dep[o] = [triple] }
        @dep[triple] = inputs
      end

      def tsort_each_child(node, &block)
        @dep[node].each(&block)
      end

      def tsort_each_node &block
        @dep.each(&block)
      end

      include TSort
    end

  end
end