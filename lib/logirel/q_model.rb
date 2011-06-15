module Logirel
  class Q
    attr_accessor :question
  end
  
  class BoolQ < Q
    attr_accessor :pos_answer, :neg_answer
    
    def initialize(question, name) 
      @question = question
  	#@pos_answer lambda { name }
  	#@neg_answer lambda { }
    end
    
    def exec
      puts @question
      #a = gets
      #a == 'yes' ? q.pos_answer.call : a == '' ? q.neg_answer.call
    end
	
	def answer
	  nil
	end
  end
  
  class StrQ < Q
    attr_accessor :default
    
    def initialize(question, default = nil, io_source = STDIN, validator = nil) 
      @question = question
      @default = default    
      @io_source = io_source
      @validator = validator || lambda { true }
    end
    
    def exec
      puts @question
      @answer = (io_source.gets || @default) while not @validator.call(@answer)
    end
	
    def answer
      @answer || @default
    end
  end
end