require 'construct'

def with_sample_projects do |&block|
  Construct::within_construct do |c|	
    # given files	
    c.directory('src/A')
    c.directory('src/B')
    c.directory('src/C')
    c.file('src/A/A.csproj') do |f|
      f.puts "cs proj file ... xml in here"
    end
    
    c.file('src/C/HelloWorld.vbproj')
	block.call(c)
  end
end