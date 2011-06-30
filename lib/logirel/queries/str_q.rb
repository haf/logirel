class StrQ < Q
  def initialize(question,
                 default = nil,
                 io_source = STDIN,
                 validator = nil,
                 io_target = STDOUT)
    @question = question
    @default = default
    @io_source = io_source
    @validator = validator || lambda { |_| true }
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
      valid = @validator.call(@answer)
    end while !valid || (!valid && @answer.empty?)
    @answer = @answer.empty? ? @default : @answer
    @io_target.puts "Chose '#{@answer}'."
    @answer
  end
end
