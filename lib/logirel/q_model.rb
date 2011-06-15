module Logirel
  class Q
    attr_accessor :question, :default
  end
  
  class BoolQ < Q
    attr_accessor :pos_answer, :neg_answer
    
    def initialize(question, 
	               default, 
	               io_source = STDIN, 
	               io_target = STDOUT)
      @question = question
	  @default = default
	  @io_source = io_source
	  @io_target = io_target
    end
	
	def default
	  @default ? "[Yn]" : "[yN]"
	end
    
    def exec
      @io_target.print @question + " " + default
	  puts "source: #{@io_source}"
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
	  begin
        @answer = @io_source.gets.chomp
	  end while !@answer.empty? && !@validator.call(@answer)
	  @answer = @answer.empty? ? @default : @answer
	  @io_target.puts "Chose '#{@answer}'."
	  @answer
    end
  end
end