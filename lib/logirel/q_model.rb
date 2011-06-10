class Q
  attr_accessor :question
end

class BoolQ < Q
  attr_accessor :pos_answer, :neg_answer
  
  def initialize(question, name) 
    @question = question
	@pos_answer = do
	  name
	end
	@neg_answer = do; nil; end
  end
  
  def exec  
	puts q.question
	a = gets
	q.pos_answer.call if a == 'yes' or a == '' else q.neg_answer.call
  end
end

class StrQ < Q
  attr_accessor :answer
  
  def initialize(question) 
    @question = question
  end
  
  def exec 
    puts @question
	@answer = gets
  end
end

class Querier
  def ask_if_user_want_to_include_project_as_package(projects)
    projects.
	  map{ |p| BoolQ.new("Would you like to include the '#{p}' project, dear Sir?") }.
	  map{ |q| q.exec }.
	  include_if { | item | item != nil }
  end
end