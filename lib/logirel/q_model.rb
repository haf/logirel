module Logirel
  class Q
    attr_accessor :question, :default
  end
  
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
  
  class StrQ < Q
    def initialize(question, 
                   default = nil, 
                   io_source = STDIN, 
                   validator = nil,
                   io_target = STDOUT)
      @question = question
      @default = default    
      @io_source = io_source
      @validator = validator || lambda { |s| true }
      @io_target = io_target      
      @answer = ""
    end
    
    def answer
      @answer.empty? ? @default : @answer
    end
    
    def exec
      @io_target.print @question + " [#{@default}]: "
	  valid = false
      begin
        @answer = @io_source.gets.chomp
		valid = @validator.call(@answer)
      end while !valid || (!valid && @answer.empty?)
      @answer = @answer.empty? ? @default : @answer
      @io_target.puts "Chose '#{@answer}'."
      @answer
    end
  end
end