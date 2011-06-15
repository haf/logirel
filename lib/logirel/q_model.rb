module Logirel
  class Q
    attr_accessor :question, :answer, :default
    
    def answer
      @answer || @default
    end
  end
  
  class BoolQ < Q
    attr_accessor :pos_answer, :neg_answer
    
    def initialize(question, name)
      @question = question
    end
    
    def exec
      puts @question
      #a = gets
      #a == 'yes' ? q.pos_answer.call : a == '' ? q.neg_answer.call
    end
  end
  
  class StrQ < Q
    def initialize(question, default = nil, io_source = STDIN, validator = nil) 
      @question = question
      @default = default    
      @io_source = io_source
      @validator = validator || lambda { |s| true }
    end
    
    def exec
      puts @question + " [#{@default}]: "
	  begin
        @answer = @io_source.gets
	  end while !@answer.empty? && !@validator.call(@answer)
	  @answer == nil || @answer.empty? ? @default : @answer
    end
  end
end