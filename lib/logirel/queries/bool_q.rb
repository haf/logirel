module Logirel
  module Queries
    class BoolQ < Q
      attr_accessor :pos_answer, :neg_answer

      def initialize(question,
          default = true,
          io_source = STDIN,
          io_target = STDOUT)
        @question = question
        @default = default
        @io_source = io_source
        @io_target = io_target
      end

      def default_str

        @default ? "[Yn]" : "[yN]"

      end

      def exec
        @io_target.print @question + " " + default_str
        a = ""
        begin
          a = @io_source.gets.chomp
        end while !a.empty? && !['y', 'n'].include?(a.downcase)
        a.empty? ? @default : (a == 'y')
      end
    end

  end
end

