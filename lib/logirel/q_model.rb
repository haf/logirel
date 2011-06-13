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
  end
  
  class StrQ < Q
    attr_accessor :answer, :default
    
    def initialize(question, default = '.') 
      @question = question
	  @default = default
    end
    
    def exec 
      puts @question
  	  @answer = gets.chomp || @default
    end
  end
  
  class Querier
    def include_package_for(projects)
      projects.
  	  map{ |p| BoolQ.new("Would you like to include the '#{p}' project, dear Sir?", p) }
    end
  end
end